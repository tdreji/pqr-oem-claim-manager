# Production Build & GitHub Repository Deployment Instructions

This document covers repository setup, dependency management, TypeScript compilation, and GitHub workflow execution.

---

## 1. Initializing and Pushing to a New GitHub Repository

```bash
# Navigate to the production directory
cd C:\Users\tdrej\.gemini\antigravity\scratch\pqr-oem-app-production

# Initialize Git repository
git init -b main

# Add all production files
git add .

# Create initial release commit
git commit -m "feat: initial production release of PQR & OEM Claim Management System with RBAC and Audit Trails"

# Connect to your remote GitHub repository
git remote add origin https://github.com/your-organization/pqr-oem-app.git

# Push to GitHub main branch
git push -u origin main
```

---

## 2. Local Production Build Execution

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Run TypeScript Type Check & Vite Production Bundle
```bash
npm run build
```
This will compile all TypeScript files into optimized static HTML, CSS, and JS bundles inside the `dist/` directory.

### Step 3: Test Production Bundle Locally
```bash
npm run preview
```
Open [http://localhost:3000](http://localhost:3000) to verify production behavior.

---

## 3. GitHub Actions CI/CD Configuration

The repository includes `.github/workflows/deploy.yml` which automatically:
1. Triggers on every push or pull request to `main` / `master`.
2. Runs `npm ci` with Node.js 22.
3. Compiles TypeScript and builds the Vite production distribution.
4. Generates downloadable deployment artifacts.

### Setting GitHub Repository Secrets (Optional)
Navigate to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

- `VITE_GOOGLE_SHEET_ID`: `1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c`
- `VITE_APPS_SCRIPT_URL`: *(Your deployed Google Apps Script Web App URL)*
- `VITE_APP_NAME`: `PQR & OEM Claim Manager`
- `VITE_COMPANY_NAME`: `Al Habtoor Motors Co. LLC`

---

## 4. Production Release Checklist

- [x] Pre-configured Admin (`wrnty@habtoormotors.com`) and Standard users (`twt@...`, `wrntyteam@...`).
- [x] Non-destructive Google Sheets integration preserving tabs `PQR`, `WarrantyQA`, `Service Interval`.
- [x] Automatic Last-Column Audit Trail format:
  ```text
  Updated By: wrnty@habtoormotors.com
  Date: 23-Aug-2026
  Time: 09:35 AM GST
  Timestamp: 2026-08-23T09:35:42+04:00
  ```
- [x] Multi-format OEM export (PDF, Word docx, Excel xlsx).
- [x] Dockerfile & Nginx setup for `pqr.carchassi.com`.
- [x] GitHub CI/CD Actions workflows.
