# PQR & OEM Technical Claim Management Platform (Production Edition)

> **Enterprise Quality Assurance & Technical Warranty Reporting System**  
> Tailored for Al Habtoor Motors Co. LLC & OEM Brand Operations (FUSO, Mitsubishi, JAC, Mercedes-Benz Trucks, Daimler Buses).

---

## 🌟 Key Highlights & System Architecture

- **Exact Functional & UI Parity**: Retains 100% of the existing PQR application workflow, sections (A–H), 25 OEM technical aggregates, multi-photo frame manager with live annotations, service history tables, and service interval matrices.
- **Enterprise User Management & RBAC**: Pre-configured role-based security with Administrator and Standard User access levels.
- **Parallel Save to Local 'PQR_Live' Folder**: Automatically exports structured data, text summaries, and high-resolution photo files to the local machine folder `PQR_Live/` concurrently with cloud sync.
- **Automatic Last-Column Audit Trail**: Automatically captures `Updated By`, `Date`, `Time (GST)`, and `Timestamp` on every create, edit, update, or save operation, storing it in the **last column** of Google Sheets and the audit log repository.
- **Seamless Google Sheets Integration**: Native zero-loss synchronization with Spreadsheet ID `1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c` (`PQR`, `WarrantyQA`, `Service Interval` tabs).
- **Multi-Format Export Engine**: Generates pixel-perfect OEM PDF reports, formatted Microsoft Word documents (`.docx`) with embedded photo tables, and Excel workbooks (`.xlsx`).
- **Domain & Cloud Ready**: Production Dockerfile and Nginx configuration pre-tuned for custom domain hosting at `pqr.carchassi.com`.

---

## 👥 User Accounts & Access Control (RBAC)

The system comes pre-configured with the following user accounts:

| Email | Password | Role | Permissions Overview |
|---|---|---|---|
| `wrnty@habtoormotors.com` | `asD654321` | **Administrator** | Full access to all modules, Create/Edit/Delete/View all PQRs, User Management, Permission Management, Reports, System Config, Audit Logs |
| `twt@habtoormotors.com` | `asd12345` | **Standard User** | View PQRs, Create PQRs, Edit assigned PQRs, Export Reports, No user management or system config |
| `wrntyteam@habtoormotors.com` | `asd12345` | **Standard User** | View PQRs, Create PQRs, Edit assigned PQRs, Export Reports, No user management or system config |

---

## 🛡️ Audit Trail Format (Stored in Google Sheet Last Column)

Every PQR record saved or synchronized automatically logs the audit metadata in the **LAST COLUMN** of the Google Sheet row:

```text
Updated By: wrnty@habtoormotors.com
Date: 23-Aug-2026
Time: 09:35 AM GST
Timestamp: 2026-08-23T09:35:42+04:00
```

---

## 🚀 Quick Start (Local Development)

### 1. Prerequisites
- Node.js 20+ or 22+ (LTS)
- npm 10+

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/your-org/pqr-oem-app.git
cd pqr-oem-app

# Install dependencies
npm install

# Start development server
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your browser.

### 3. Production Build
```bash
# Compile TypeScript & bundle with Vite
npm run build

# Preview production build locally
npm run preview
```

---

## 🐳 Docker Deployment (`pqr.carchassi.com`)

Run the application with Docker and Nginx in one command:

```bash
# Build and run container
docker-compose up -d --build
```
The application will be served on port 80 with gzip compression, caching, and SPA routing.

---

## 📁 Repository Structure

```
pqr-oem-app-production/
├── .github/workflows/
│   └── deploy.yml              # CI/CD Automated Build & Test Pipeline
├── docker/
│   ├── Dockerfile              # Multi-stage optimized Node 22 -> Nginx container
│   └── nginx.conf              # Production Nginx reverse proxy configuration
├── src/
│   ├── auth/                   # Authentication, User Store, RBAC & Audit Engine
│   │   ├── AuthContext.tsx
│   │   ├── authService.ts
│   │   └── LoginModal.tsx
│   ├── components/             # UI Components (Dashboard, Form, Admin, Audit Logs)
│   │   ├── Navbar.tsx
│   │   ├── Dashboard.tsx
│   │   ├── VehicleInfoSection.tsx
│   │   ├── FailureDocumentsSection.tsx
│   │   ├── PhotoManagementModule.tsx
│   │   ├── ServiceIntervalView.tsx
│   │   ├── WarrantyQAView.tsx
│   │   ├── AdminModal.tsx
│   │   ├── UserManagementView.tsx
│   │   └── AuditLogsView.tsx
│   ├── services/               # Google Sheets, IndexedDB, and Document Exporters
│   │   ├── googleSheets.ts
│   │   ├── storageService.ts
│   │   ├── docxGenerator.ts
│   │   ├── pdfGenerator.ts
│   │   └── excelGenerator.ts
│   ├── types/                  # TypeScript interfaces for PQR, Auth, and Audit
│   │   ├── auth.ts
│   │   └── pqr.ts
│   ├── config/                 # Environment variable configurations
│   ├── data/                   # Technical Matrices & Initial Values
│   ├── App.tsx                 # Core Application Controller
│   └── main.tsx                # Entry Point
├── DEPLOYMENT_GUIDE.md         # Custom Domain & SSL Deployment Manual
├── GOOGLE_SHEETS_GUIDE.md      # Google Sheets & Apps Script Setup Guide
├── DATABASE_AND_PERMISSIONS.md # Security, Roles & Database Architecture
├── PRODUCTION_BUILD_INSTRUCTIONS.md # GitHub Push & Production Checklist
└── package.json
```

---

## 📄 Documentation Deliverables

- 📘 [DEPLOYMENT_GUIDE.md](file:///C:/Users/tdrej/.gemini/antigravity/scratch/pqr-oem-app-production/DEPLOYMENT_GUIDE.md): Custom domain setup for `pqr.carchassi.com`, SSL, VPS, Vercel, Netlify.
- 📗 [GOOGLE_SHEETS_GUIDE.md](file:///C:/Users/tdrej/.gemini/antigravity/scratch/pqr-oem-app-production/GOOGLE_SHEETS_GUIDE.md): Spreadsheet structure, Apps Script installation with last-column audit trail.
- 📙 [DATABASE_AND_PERMISSIONS.md](file:///C:/Users/tdrej/.gemini/antigravity/scratch/pqr-oem-app-production/DATABASE_AND_PERMISSIONS.md): User management, permission matrix, and audit logging schema.
- 📕 [PRODUCTION_BUILD_INSTRUCTIONS.md](file:///C:/Users/tdrej/.gemini/antigravity/scratch/pqr-oem-app-production/PRODUCTION_BUILD_INSTRUCTIONS.md): Build commands, GitHub setup, and CI/CD.
