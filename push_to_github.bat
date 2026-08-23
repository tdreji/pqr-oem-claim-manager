@echo off
title Push PQR OEM Application to GitHub
echo ======================================================================
echo Pushing PQR OEM Application to https://github.com/tdreji/pqr-oem-claim-manager.git
echo ======================================================================
echo.

set PATH=C:\Users\tdrej\AppData\Local\Programs\MinGit\cmd;%PATH%

git push -u origin main

echo.
if %ERRORLEVEL% equ 0 (
    echo ======================================================================
    echo SUCCESS: Project pushed to GitHub repository!
    echo URL: https://github.com/tdreji/pqr-oem-claim-manager
    echo ======================================================================
) else (
    echo.
    echo If GitHub prompted for credentials, you can use your GitHub Personal Access Token (PAT) as password.
    echo Generate a token at: https://github.com/settings/tokens (select 'repo' scope).
)
pause
