# Security Toolkit
## Under Development
A personal, modular security automation toolkit designed for fast usage across different machines and environments.

This repository exists to solve a simple problem:

> When switching to a new PC, VM or lab environment, I want my own scripts ready to use in minutes.

---

## Goals

- Fast setup on any machine  
- Modular and reusable scripts  
- Optimized for VPN / lab / CTF environments  
- Minimal dependencies  
- Easy chaining between tools  

---

## What This Repo Is

- A personal toolbox, not a monolithic framework  
- A growing collection of small, focused scripts  
- A base for future automation and pipelines  

---

## Repository Structure

```text
security-toolkit/
│
├── discovery/
│   ├── host_discovery.sh
│   └── README.md
│
├── docs/
│   └── methodology.md
│
├── README.md
└── LICENSE
```
Each directory represents a stage or category of security testing.

---

## Quick Start

### Clone the repository

```bash
git clone https://github.com/<your-username>/security-toolkit.git
cd security-toolkit
```

### Make Scripts Executable
```bash
find . -type f -name "*.sh" -exec chmod +x {} \;
```
### Optional: Add to PATH for global usage
```bash
export PATH=$PATH:$(pwd)/discovery
```
### Or Permanently
```bash
echo 'export PATH=$PATH:/path/to/security-toolkit/discovery' >> ~/.bashrc
```
# Available Tools
## Host Discovery
### Location
```
discovery/host_discovery.sh
```
### Purpose
- Fast identifcatiın of live hosts
- Designed for VPN/Lab networks
- Multiple discovery metthods and output formats
Example Usage:
```bash
./discovery/host_discovery.sh -t 10.10.14.0/23 -m tcp -s fast -o ip
```
### Design Mentality
-One script equals one responsibility
-Readable over clever
-Output should be reusable by other tools
-Bash-first, Python when necessary
#### Legal and Ethical Notice
This toolkit is intended only for authorized testing, labs, and educational purposes.
Do not use these scripts on systems you do not own or have explicit permission to test.
#### Licence 
MIT Licence
