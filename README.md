# 🌐 Online-Browser-Manager

Run fully functional, up-to-date web browsers (Chromium, Firefox, Opera, Mullvad) directly in your web browser via Docker. 

This project is **optimized for Google Cloud Shell**, but works on any Linux machine with Docker installed. It uses the actively maintained [LinuxServer.io](https://www.linuxserver.io/) images, ensuring you always have the latest security patches and web standards.

## ✨ Features
- 🚀 **Always Updated:** Pulls the latest stable browser versions.
- 💾 **Persistent Storage:** Your bookmarks, passwords, and downloads are saved to your host machine (`$HOME`).
- 🛡️ **Secure:** Runs with restricted user permissions (`PUID=1000`, `PGID=1000`) and sandboxed environments.
- 📱 **noVNC Powered:** Access the browser GUI directly through any modern web browser without installing VNC clients.
- 🛠️ **All-in-One Manager:** An interactive bash script to install, start, stop, and remove browsers easily.

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/waldchaibrachid/Online-Browser-Manager.git
cd Online-Browser-Manager
```

### 2. Make the Script Executable
```bash
chmod +x browser-manager.sh
```

### 3. Run the Manager
```bash
./browser-manager.sh
```
Follow the on-screen menu to install your browser of choice!

---

## ☁️ Google Cloud Shell Instructions

If you are running this in [Google Cloud Shell](https://shell.google.com/), follow these specific steps to access your browser:

1. Run the `./browser-manager.sh` script and choose **Install**.
2. Wait ~30 seconds for the image to download and start.
3. In the top-right corner of the Cloud Shell toolbar, click the **Web Preview** icon (👁️).
4. Select **Preview on port 6080**.
5. A new tab will open with your fully functional browser! 
   *(Note: If you see a Google login screen, that is the browser itself asking you to sign in. This is normal).*

---

## ⚙️ Manual Installation (Without Script)

If you prefer to run the Docker commands manually, here are the optimized commands:

**Chromium:**
```bash
docker run -d --name=chromium --shm-size="2gb" -p 6080:3000 -v $HOME/chromium-config:/config -e PUID=1000 -e PGID=1000 -e TZ=UTC --security-opt seccomp=unconfined --restart unless-stopped lscr.io/linuxserver/chromium:latest
```

**Firefox:**
```bash
docker run -d --name=firefox --shm-size="2gb" -p 6080:3000 -v $HOME/firefox-config:/config -e PUID=1000 -e PGID=1000 -e TZ=UTC --security-opt seccomp=unconfined --restart unless-stopped lscr.io/linuxserver/firefox:latest
```

---

## 🧹 Cleanup

To completely remove a browser and its saved data, replace `<browser_name>` with `chromium`, `firefox`, `opera`, or `mullvad-browser`:

```bash
docker stop <browser_name> && docker rm <browser_name>
rm -rf $HOME/<browser_name>-config
```

---

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).
