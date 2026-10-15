# Online-Browser-Manager
# 🌐 Dockerized Web Browsers (noVNC)

Run fully functional, up-to-date web browsers (Chromium, Firefox, Opera, Mullvad) directly in your web browser via Docker. 

This project is **optimized for Google Cloud Shell**, but works on any Linux machine with Docker installed. It uses the actively maintained [LinuxServer.io](https://www.linuxserver.io/) images, ensuring you always have the latest security patches and web standards.

## ✨ Features
- 🚀 **Always Updated:** Pulls the latest stable browser versions.
- 💾 **Persistent Storage:** Your bookmarks, passwords, and downloads are saved to your host machine (`$HOME`).
- 🛡️ **Secure:** Runs with restricted user permissions (`PUID=1000`, `PGID=1000`) and sandboxed environments.
- 📱 **NoVNC Powered:** Access the browser GUI directly through any modern web browser without installing VNC clients.
- 🛠️ **All-in-One Manager:** An interactive bash script to install, start, stop, and remove browsers easily.

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
https://github.com/waldchaibrachid/Online-Browser-Manager.git
