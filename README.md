# 🎖️ OpenSSL TLS Compliance Checker & Hybrid PQC Infrastructure

[![Bash Shell](https://img.shields.io/badge/Shell-Bash-4EAA25.svg?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![OpenSSL 3.0+](https://img.shields.io/badge/OpenSSL-3.0+-721412.svg?style=flat&logo=openssl&logoColor=white)](https://www.openssl.org/)
[![Protocol: TLS 1.3](https://img.shields.io/badge/Protocol-TLS__1.3-blue.svg?style=flat)](#)
[![PQC: ML-DSA-87](https://img.shields.io/badge/PQC-ML--DSA--87-purple.svg?style=flat)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat)](https://opensource.org/licenses/MIT)

## 👤 Student Information
* **University:** Harokopio University of Athens (HUA)
* **Master's Program:** MSc in Advances in Computer Science and Informatics Systems
* **Course:** Cyber Security
* **Student Name:** Drosos Katsimpras
* **Repository:** [openssl-tls-compliance-checker](https://github.com/drososkats/openssl-tls-compliance-checker)

---

## 📌 Overview
This repository contains a professional-grade TLS evaluation suite and cryptographic infrastructure toolset developed as part of the **Master's in Advances in Computer Science and Informatics Systems at Harokopio University of Athens**. 

The project implements an automated **Security Compliance Engine** designed to audit remote and local web servers against modern cryptographic standards. Furthermore, it demonstrates **Crypto-Agility** by establishing a hybrid Public Key Infrastructure (PKI) capable of bridging classical asymmetric cryptography with Quantum-Resistant algorithms.

---

## 🗂️ Repository Structure

```
openssl-tls-compliance-checker/
├── certificates/
│   ├── rsa/          # Q1: RSA-15360 self-signed certificate
│   ├── ecdsa/        # Q1: ECDSA P-521 self-signed certificate
│   ├── eddsa/        # Q1: EdDSA Ed448 self-signed certificate
│   ├── pqc/          # Q1: PQC ML-DSA-87 self-signed certificate
│   ├── chain/        # Q2: Hybrid certificate chain (4 levels)
│   └── nginx_weak/   # BONUS: Intentionally weak certificate
├── scripts/
│   └── ssl_inspector.sh  # Q3: Automated TLS compliance checker
└── results/
    └── testssl_dit_hua_gr.log  # Q4: testssl.sh scan results
```
---

## 🚀 Phases

### Phase 1 — Hybrid PKI (Q1 + Q2)
- 4 self-signed certificates with ≥256-bit security level
- RSA-15360, ECDSA P-521, EdDSA Ed448, PQC ML-DSA-87
- Hybrid certificate chain: Root CA → Int1 → Int2 → Leaf
- OQS Provider for OpenSSL 3.0.x PQC support

### Phase 2 — Compliance Tool (Q3)
- `ssl_inspector.sh`: automated TLS/SSL checker
- Checks: TLS version, weak ciphers, certificate criteria
- Tested against badssl.com (5 vulnerabilities)
- Weak Nginx local server audit

### Phase 3 — Real-World Audit (Q4)
- Target: `dit.hua.gr`
- Tools: `testssl.sh` + Qualys SSL Labs
- Results: Grade A+ (testssl) / Grade A (Qualys)

---

## 🛠️ Usage

```bash
# Run SSL Inspector
bash scripts/ssl_inspector.sh <target> <port>

# Examples:
bash scripts/ssl_inspector.sh expired.badssl.com 443
bash scripts/ssl_inspector.sh localhost 443
bash scripts/ssl_inspector.sh dit.hua.gr 443
```

---

## 📋 Requirements

Ubuntu 22.04/24.04
OpenSSL 3.0.x
OQS Provider (for PQC support)
Nginx 

---

## 📄 License
MIT License — Drosos Katsimpras, HUA 2026