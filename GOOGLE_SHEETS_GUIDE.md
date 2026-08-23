# Google Sheets Connection & Last-Column Audit Trail Setup

This document provides instructions for linking the PQR & OEM Claim Management System to your Google Spreadsheet and configuring the Google Apps Script webhook to capture the mandatory **Last-Column Audit Trail**.

---

## 1. Spreadsheet Overview

- **Spreadsheet ID**: `1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c`
- **Spreadsheet URL**: `https://docs.google.com/spreadsheets/d/1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c/edit`
- **Target Sheets (Tabs)**:
  1. `PQR`: Stores submitted and synced warranty claim records.
  2. `WarrantyQA`: Master bank of technical inspection questions and answers.
  3. `Service Interval`: Scheduled maintenance intervals matrix.

---

## 2. Column Structure & Last-Column Audit Trail

The PQR sheet uses the following standard column sequence:

| Col # | Column Name | Sample Value |
|---|---|---|
| A | Brand * | FUSO |
| B | Model * | CANTER |
| C | Model Code | FE84PG6SL |
| D | Aggregate * | Engine |
| E | Country | United Arab Emirates |
| F | PQR Number * | PQR-2026-0001 |
| G | VIN / Chassis No * | JL6BDG6A0SK015294 |
| H | Engine Number | 4D34-2AT4 |
| I | Transmission Number | M025S5 |
| J | Registration Date | 15-Jan-2025 |
| K | Failure Date * | 23-Aug-2026 |
| L | Repair Date | 23-Aug-2026 |
| M | Mileage (km) | 45000 |
| N | Complaint * | Engine oil leakage from rear main seal |
| O | Claim Status | Open |
| P | SR Number | SR-88921 |
| Q | Ascent Ticket | ASC-10492 |
| R | Problem in Brief (Section A) | Oil drops noticed under flywheel housing |
| S | Problem Diagnosis & Technical Observations (Section B) | Rear crankshaft oil seal cracked and hardened |
| T | Repair Needed / Performed (Section D) | Replace crankshaft rear oil seal and clean housing |
| U | Suspected Root Cause (Section E) | Thermal degradation of elastomer seal |
| V | Periodic Service History (Section F) | Date: 10-Jan-2026 \| 40000km \| Oil & filters \| Regular PM |
| W | Comments & Requests (Section G) | Requesting OEM approval for warranty reimbursement |
| X | Other Observations (Section H) | Clutch disc checked; dry and unaffected |
| Y | Total Photos Attached | 4 |
| Z | Photo Remarks Catalog | Photo #1: Oil dripping; Photo #2: Removed seal |
| AA+ | Dynamic Q&A Pairs | Question 1 \| Answer 1 ... |
| **LAST** | **Audit Trail Information** | *(See format below)* |

### Mandatory Audit Trail Format:
```text
Updated By: wrnty@habtoormotors.com
Date: 23-Aug-2026
Time: 09:35 AM GST
Timestamp: 2026-08-23T09:35:42+04:00
```

---

## 3. Google Apps Script Webhook Installation

To enable direct, non-destructive synchronization from the web application:

### Step 1: Open Google Sheets Apps Script
1. Open spreadsheet `1QNhGBIunSARRgKq4KEMCzBzJS-mz-_DaA-Dvq-Zyb0c`.
2. Click **Extensions** → **Apps Script**.

### Step 2: Paste the Script Code
Delete any existing code in `Code.gs` and paste the following:

```javascript
// ====================================================================
// Safe Non-Destructive Google Apps Script for PQR & OEM Claim Manager
// Preserves Row 1 Headers & Writes Audit Trail to Last Column
// ====================================================================

function doPost(e) {
  try {
    var raw = e.postData ? e.postData.contents : "{}";
    var payload = JSON.parse(raw);
    var action = payload.action || "savePQR";
    var ss = SpreadsheetApp.getActiveSpreadsheet();

    // 1. SAVE PQR CLAIM (With Audit Trail in Last Column)
    if (action === "savePQR") {
      var sheetName = payload.sheetName || "PQR";
      var sheet = ss.getSheetByName(sheetName);
      if (!sheet) { sheet = ss.insertSheet(sheetName); }
      
      var values = payload.values || [];
      var pqrNo = payload.pqrNumber;
      var existingRow = -1;
      
      // Check column F (Row 2 onwards) for matching PQR number
      if (sheet.getLastRow() > 1 && pqrNo) {
        var pqrValues = sheet.getRange(2, 6, sheet.getLastRow() - 1, 1).getValues();
        for (var i = 0; i < pqrValues.length; i++) {
          if (pqrValues[i][0] == pqrNo) {
            existingRow = i + 2;
            break;
          }
        }
      }
      
      // Update existing row or append new row
      if (existingRow > 1 && values.length > 0) {
        sheet.getRange(existingRow, 1, 1, values.length).setValues([values]);
      } else if (values.length > 0) {
        sheet.appendRow(values);
      }
      
      return jsonResponse({ 
        status: "success", 
        action: "savePQR", 
        pqrNumber: pqrNo, 
        auditUser: payload.auditUser || "wrnty@habtoormotors.com" 
      });
    }

    // 2. SAVE QUESTION TO QUESTION BANK (WarrantyQA)
    if (action === "saveQuestion") {
      var qSheet = ss.getSheetByName("WarrantyQA");
      if (!qSheet) { qSheet = ss.insertSheet("WarrantyQA"); }
      var qData = payload.data || {};
      
      var qRow = [
        qData.brand || "",
        qData.model || "",
        qData.aggregate || "Engine",
        qData.area || "Inspection Findings",
        qData.question || "",
        qData.answer || ""
      ];
      
      qSheet.appendRow(qRow);
      return jsonResponse({ status: "success", action: "saveQuestion" });
    }

    // 3. SAVE SERVICE INTERVAL
    if (action === "saveServiceInterval") {
      var sSheet = ss.getSheetByName("Service Interval");
      if (!sSheet) { sSheet = ss.insertSheet("Service Interval"); }
      var sData = payload.data || {};
      
      var sRow = [
        sData.brand || "",
        sData.model || "",
        sData.aggregate || "Engine",
        sData.variant || "",
        sData.transmission || "",
        sData.partNumber || "",
        sData.serviceItem || "",
        sData.initialIntervalKm || "",
        sData.initialIntervalMonths || "",
        sData.initialIntervalEngineHours || "",
        sData.normalIntervalKm || "",
        sData.regularIntervalMonths || "",
        sData.regularIntervalEngineHours || "",
        sData.remarks || ""
      ];
      
      sSheet.appendRow(sRow);
      return jsonResponse({ status: "success", action: "saveServiceInterval" });
    }

    return jsonResponse({ status: "unknown_action" });

  } catch (err) {
    return jsonResponse({ status: "error", message: err.toString() });
  }
}

function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data)).setMimeType(ContentService.MimeType.JSON);
}

function doGet(e) {
  return ContentService.createTextOutput(JSON.stringify({
    status: "online",
    system: "PQR & OEM Technical Warranty Hub Webhook",
    lastColumnAuditTrail: true
  })).setMimeType(ContentService.MimeType.JSON);
}
```

### Step 3: Deploy as Web App
1. Click **Deploy** → **New deployment**.
2. Select type: **Web app**.
3. Set **Execute as**: `Me (your Google account)`.
4. Set **Who has access**: `Anyone`.
5. Click **Deploy** and copy the **Web app URL**.

### Step 4: Configure the Webhook in the App
1. In the PQR application, open **Admin Console** (top right) → **Google Sheets Integration**.
2. Paste the Web app URL into **Google Apps Script Webhook URL**.
3. Click **Save Sheet Config** and test by saving any PQR claim.
