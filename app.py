"""
MarketPulse Main Application Entry Point.
Launches the FastAPI backend and Streamlit fintech dashboard in one command.
"""

import sys
import os
import time
import socket
import threading
import subprocess
import webbrowser
from pathlib import Path

# Add project root to sys.path
PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from database.repository import MarketPulseRepository
from orchestration.graph import MarketPulsePipeline


def is_port_in_use(port: int) -> bool:
    """Check whether a local TCP port is already open/occupied."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(("localhost", port)) == 0


def run_fastapi_server():
    """Start FastAPI Uvicorn server on port 8000."""
    import uvicorn
    uvicorn.run("api.main:app", host="127.0.0.1", port=8000, log_level="warning")


def main():
    print("=" * 65)
    print("⚡ MarketPulse: AI-Powered Financial News Intelligence Platform")
    print("=" * 65)

    # 1. Initialize SQLite Database & Seeding
    print("[1/3] Initializing local database & company master...")
    repo = MarketPulseRepository()
    repo.init_database()
    companies = repo.get_companies_list()
    print(f"      ✓ SQLite ready. Verified companies: {len(companies)}")

    # 2. Check and Seed Initial Stories if empty
    articles_count = repo.get_articles_count()
    if articles_count == 0:
        print("[2/3] Seeding initial financial news benchmark dataset...")
        pipeline = MarketPulsePipeline(repository=repo)
        res = pipeline.run_pipeline()
        print(f"      ✓ Pipeline initialized. Formed {len(res.get('stories', []))} stories.")
    else:
        print(f"[2/3] Found {articles_count} articles and {len(repo.get_all_stories(limit=100))} stories in database.")

    # 3. Start FastAPI Backend if not already running on port 8000
    if not is_port_in_use(8000):
        print("[3/3] Starting FastAPI REST backend on http://localhost:8000...")
        api_thread = threading.Thread(target=run_fastapi_server, daemon=True)
        api_thread.start()
        time.sleep(1.5)
        print("      ✓ FastAPI online.")
    else:
        print("[3/3] FastAPI already running on port 8000.")

    # 4. Launch Streamlit Frontend
    streamlit_port = 8501
    streamlit_url = f"http://localhost:{streamlit_port}"
    print(f"\n⚡ Launching MarketPulse Dashboard at {streamlit_url}")
    print("Press Ctrl+C to terminate application.\n")

    frontend_script = str(PROJECT_ROOT / "frontend" / "app.py")
    python_exe = sys.executable

    # Open default web browser after short delay
    threading.Timer(2.0, lambda: webbrowser.open(streamlit_url)).start()

    # Launch Streamlit process
    cmd = [
        python_exe,
        "-m",
        "streamlit",
        "run",
        frontend_script,
        "--server.port",
        str(streamlit_port),
        "--server.headless",
        "false",
        "--browser.serverAddress",
        "localhost",
        "--theme.base",
        "dark",
    ]

    try:
        subprocess.run(cmd, check=True)
    except KeyboardInterrupt:
        print("\nShutting down MarketPulse cleanly. Goodbye!")


if __name__ == "__main__":
    main()
