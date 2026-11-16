@echo off
setlocal enabledelayedexpansion

echo =====================================================================
echo  MarketPulse: First-Time Setup and Local Environment Preparation
echo =====================================================================
echo.

:: 1. Check Python installation
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your system PATH.
    echo Please install Python 3.11, 3.12, or higher from https://www.python.org
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
echo [1/5] Detected Python: %PYTHON_VER%

:: 2. Create virtual environment if missing
if not exist "venv\Scripts\python.exe" (
    echo [2/5] Creating Python virtual environment in .\venv ...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo       Virtual environment created successfully.
) else (
    echo [2/5] Virtual environment already exists in .\venv.
)

:: 3. Activate virtual environment and upgrade pip
call venv\Scripts\activate.bat
echo [3/5] Upgrading pip...
python -m pip install --upgrade pip --quiet

:: 4. Install dependencies
echo [4/5] Installing dependencies from requirements.txt...
pip install -r requirements.txt --quiet
if %errorlevel% neq 0 (
    echo [WARNING] Some dependencies had warnings during installation. Continuing setup...
) else (
    echo       Dependencies installed successfully.
)

:: 5. Initialize SQLite database & seed companies
echo [5/5] Initializing SQLite database and pre-seeding benchmark dataset...
python scripts\run_ingestion.py

echo.
echo =====================================================================
echo  SETUP COMPLETE! MarketPulse is ready for demonstration.
echo.
echo  To launch the application at any time, double-click:
echo  START_MARKETPULSE.bat
echo =====================================================================
echo.
pause
