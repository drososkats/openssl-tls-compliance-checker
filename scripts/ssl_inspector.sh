#!/bin/bash
# ssl_inspector.sh - TLS/SSL Compliance Checker
# Author: Drosos Katsimpras - (ais25123) - HUA MSc 2026

TARGET=${1:-"badssl.com"}
PORT=${2:-443}

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS="${GREEN}[SECURITY PASS]${NC}"
FAIL="${RED}[SECURITY FAIL]${NC}"
INFO="${YELLOW}[INFO]${NC}"

echo "**********************************************************"
echo " SSL Inspector — Target: $TARGET:$PORT"
echo "**********************************************************"

#Check 1: TLS Version
echo ""
echo "--- Check 1: TLS Protocol Version ---"

for version in "-tls1" "-tls1_1"; do
    result=$(echo | openssl s_client \
        -connect "$TARGET:$PORT" \
        $version 2>&1 | grep -c "Cipher is")
    if [ "$result" -gt 0 ]; then
        echo -e "$FAIL $version is ACCEPTED (${RED}insecure!${NC})"
    else
        echo -e "$PASS $version is REJECTED"
    fi
done

for version in "-tls1_2" "-tls1_3"; do
    result=$(echo | openssl s_client \
        -connect "$TARGET:$PORT" \
        $version 2>&1 | grep -c "Cipher is")
    if [ "$result" -gt 0 ]; then
        echo -e "$PASS $version is SUPPORTED"
    else
        echo -e "$INFO ${YELLOW} $version not supported"
    fi
done

# CHECK 2: WEAK CIPHERS
echo ""
echo "--- CHECK 2: Weak Cipher Suites ---"

WEAK_CIPHERS="SHA RC4 3DES NULL aNULL eNULL"
for cipher in $WEAK_CIPHERS; do
    result=$(echo | openssl s_client \
        -connect "$TARGET:$PORT" \
        -cipher "$cipher" 2>&1 | grep -c "Cipher is")
    if [ "$result" -gt 0 ]; then
        echo -e "$FAIL Cipher $cipher is ACCEPTED (${RED}insecure!${NC})"
    else
        echo -e "$PASS Cipher $cipher is REJECTED"
    fi
done

# CHECK 3: CERTIFICATE CRITERIA
echo ""
echo "--- CHECK 3: Certificate Validation ---"

CERT=$(echo | openssl s_client \
    -connect "$TARGET:$PORT" 2>/dev/null | \
    openssl x509 2>/dev/null)

if [ -z "$CERT" ]; then
    echo -e "$FAIL Could not retrieve certificate"
    exit 1
fi

# Expiry check
EXPIRY=$(echo "$CERT" | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null)
NOW_EPOCH=$(date +%s)

if [ "$EXPIRY_EPOCH" -lt "$NOW_EPOCH" ]; then
    echo -e "$FAIL Certificate ${RED}EXPIRED${NC} on: $EXPIRY"
else
    DAYS=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))
    echo -e "$PASS Certificate valid for $DAYS more days (expires: $EXPIRY)"
fi

# CN check
CN=$(echo "$CERT" | openssl x509 -noout -subject 2>/dev/null | grep -oP 'CN\s*=\s*\K[^,]+')
echo -e "$INFO ${YELLOW}Certificate CN: $CN"

if echo "$CN" | grep -q "$TARGET" || echo "$CN" | grep -q "\*"; then
    echo -e "$PASS CN matches target domain"
else
    echo -e "$FAIL CN mismatch! Expected: $TARGET, Got: $CN"
fi

echo ""
echo "**********************************************************"
echo " Scan complete!"
echo "**********************************************************"