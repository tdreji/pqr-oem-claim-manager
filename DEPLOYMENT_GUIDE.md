# Complete Production & GitHub Deployment Guide

This guide covers:
1. **Pushing and Deploying to GitHub** (GitHub Pages / GitHub Actions / VPS Webhooks)
2. **Custom Domain Setup** (`pqr.carchassi.com`) with Nginx & Let's Encrypt SSL
3. **Local Machine `PQR_Live` Folder Setup** (Parallel saving with photos & Google Sheets)

---

## 1. Pushing the Code to GitHub

Open PowerShell on your computer and run these commands:

```powershell
# 1. Navigate to the project directory
cd C:\Users\tdrej\.gemini\antigravity\scratch\pqr-oem-app-production

# 2. Initialize Git (if not already initialized)
git init -b main

# 3. Add all production files
git add .

# 4. Commit the release
git commit -m "feat: complete production release of PQR & OEM Claim Management System with RBAC, Audit Trail, and PQR_Live folder sync"

# 5. Link to your GitHub repository (replace with your repo URL)
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/pqr-oem-app.git

# 6. Push to GitHub
git push -u origin main
```

---

## 2. Deploying via GitHub Pages / GitHub Actions (Free Hosting)

The repository includes a ready-to-run GitHub Actions workflow (`.github/workflows/deploy.yml`).

### To enable GitHub Pages hosting:
1. Go to your GitHub repository on [github.com](https://github.com).
2. Click **Settings** → **Pages**.
3. Under **Build and deployment** → **Source**, select **GitHub Actions**.
4. Every push to `main` will automatically build and deploy the app!

### To deploy to Vercel / Netlify with GitHub:
1. Connect your GitHub account at [vercel.com](https://vercel.com) or [netlify.com](https://netlify.com).
2. Select your repository `pqr-oem-app`.
3. Set **Build Command**: `npm run build` and **Output Directory**: `dist`.
4. Under **Custom Domains**, add `pqr.carchassi.com`.

---

## 3. Parallel Saving to Local Folder `PQR_Live`

### A. Automatic Local Folder Creation
A dedicated folder named **`PQR_Live`** has been created on your local machine:
📁 **`C:\Users\tdrej\Desktop\PQR_Live`**

### B. How Parallel Saving Works:
Whenever any PQR claim is saved (**Save PQR Changes** or **Save As New PQR**):
1. **Google Sheets Parallel Push**: Synchronizes the claim row into your Google Sheet (`1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c`) with the **Last Column Audit Trail**:
   ```text
   Updated By: wrnty@habtoormotors.com
   Date: 23-Aug-2026
   Time: 09:35 AM GST
   Timestamp: 2026-08-23T09:35:42+04:00
   ```
2. **Local Machine `PQR_Live` Folder Save**:
   - Creates a dedicated subfolder for the claim: `PQR_Live/{PQR_NUMBER}/`
   - Saves `claim_data.json` (complete structured metadata).
   - Saves `claim_summary.txt` (clean formatted text summary).
   - Saves `photos/` folder containing each attached image file (`Photo_1_....jpg`, `Photo_2_....jpg`, etc.).
3. **One-Click Folder Link in Header**:
   - In the top header, click **Link PQR_Live** (or **Save to PQR_Live** in the footer) to link directly to `C:\Users\tdrej\Desktop\PQR_Live` using the Web File System API.

---

## 4. Custom Domain & DNS Setup (`pqr.carchassi.com`)

| Record Type | Host | Points To / Value | TTL |
|---|---|---|---|
| **A** (for VPS/Docker) | `pqr` | `YOUR_SERVER_PUBLIC_IP` | 300s |
| **CNAME** (for Vercel/Netlify) | `pqr` | `cname.vercel-dns.com` | Auto |

---

## 5. Docker & Nginx Deployment (Self-Hosted Linux Server)

```bash
# Clone and run
git clone https://github.com/YOUR_GITHUB_USERNAME/pqr-oem-app.git
cd pqr-oem-app
docker compose up -d --build
```
