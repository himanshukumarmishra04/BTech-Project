@echo off
setlocal

echo =====================================================================
echo  Starting MarketPulse Financial Intelligence Platform...
echo =====================================================================
echo.

:: 1. Check if virtual environment exists
if not exist "venv\Scripts\python.exe" (
    echo [ERROR] Virtual environment not found!
    echo Please run SETUP_MARKETPULSE.bat first to configure the environment.
    echo.
    pause
    exit /b 1
)

:: 2. Activate virtual environment
call venv\Scripts\activate.bat

:: 3. Launch the single entry point application
echo Starting MarketPulse servers (FastAPI + Streamlit)...
echo The browser will open automatically at http://localhost:8501
echo.
python app.py

pause
