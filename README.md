# MarketPulse ⚡

### An AI-Powered Multi-Agent System for Real-Time Financial News Intelligence and Impact-Aware Ranking

[![Python Version](https://img.shields.io/badge/Python-3.11%20%7C%203.12%20%7C%203.14-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-Academic%20Research-purple.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20Local-green.svg)]()
[![Cost](https://img.shields.io/badge/API%20Cost-100%25%20Free%20%2F%20Zero-brightgreen.svg)]()

---

## 🎓 Academic Project Information

- **Institution:** Delhi Technological University (DTU), Formerly Delhi College of Engineering
- **Department:** Computer Science and Engineering
- **Programme:** Bachelor of Technology (B.Tech)
- **Academic Year:** 2026 – 2027
- **Group Key:** A5
- **Faculty Supervisor:** Prof. Vinod Kumar
- **Submitted To:** Dr. Anurag Goel

### 👥 Team Members

| Name | Roll Number | Primary Module Ownership |
| :--- | :--- | :--- |
| **K G Narasimha** | 23/CS/198 | Ingestion, Database, Deduplication & LangGraph Orchestration |
| **Himanshu Kumar Mishra** | 23/CS/176 | Entity Extraction (NER), Ticker Linking & Confidence Scoring |
| **Sarthak Singh Meena** | 23/CS/381 | Ranking Engine, Grounded Evidence, FastAPI & Streamlit Frontend |
| **Rishabh Kumar Gautam** | 24/CS/367 | Test Sets, Evaluation Benchmarking & Documentation |

---

## 📌 Executive Summary

Every trading day, Indian financial markets generate an overwhelming volume of corporate announcements, quarterly earnings, regulatory circulars from RBI and SEBI, and multi-outlet financial news. When a major event occurs (such as an RBI repo rate decision), dozens of outlets report the identical story with slight lexical variations. Analysts and investors waste cognitive bandwidth reading duplicate articles without clear, verifiable visibility into which listed companies are directly impacted.

**MarketPulse** solves this problem through an on-device, zero-cost, six-agent pipeline coordinated via stateful graph orchestration. It:
1. Clusters multi-outlet reports into unified events via dense representations and cosine similarity.
2. Extracts companies, regulators, and sectors using a verified Nifty 50 reference master.
3. Maps company-specific impact (Positive, Negative, Neutral) with an auditable confidence score and quotes verbatim supporting sentences from the text.
4. Ranks intelligence via a multi-factor formula combining semantic similarity, company relevance, recency, and impact confidence.
5. Runs 100% locally on Windows without paid external AI subscriptions.

> ⚠️ **Important Boundary:** MarketPulse is strictly an **Information Retrieval (IR) and Explainable Financial Intelligence** system. It is **not** a trading bot, not a stock price forecaster, and not an investment advisory service.

---

## 🏛️ System Architecture

```mermaid
flowchart TD
    subgraph DataSources["Financial News Sources"]
        NSE["NSE India Announcements"]
        RBI["RBI Regulatory Circulars"]
        SEBI["SEBI Press Releases"]
        ET["Economic Times / Business Standard"]
    end

    subgraph LangGraph["Six-Agent LangGraph Pipeline"]
        A1["Agent 1: News Ingestion\n(feedparser + text cleaner)"]
        A2["Agent 2: Deduplication\n(Embeddings + Cosine Similarity)"]
        A3["Agent 3: Entity Extraction\n(spaCy NER + RapidFuzz Nifty 50)"]
        A4["Agent 4: Impact Mapping\n(Sentiment + Verbatim Evidence)"]
        A5["Agent 5: Storage Agent\n(SQLite with WAL Mode)"]
        A6["Agent 6: Vector Indexing\n(Story & Sentence Representation)"]

        A1 --> A2 --> A3 --> A4 --> A5 --> A6
    end

    subgraph Delivery["Backend & User Interface"]
        API["FastAPI REST Backend (Port 8000)"]
        UI["Streamlit Dark Fintech Dashboard (Port 8501)"]
    end

    DataSources --> A1
    A5 -.-> API
    A6 -.-> API
    API <--> UI
```

---

## 🤖 The Six Autonomous Agents

| Agent | Responsibility | Key Technique / Library |
| :--- | :--- | :--- |
| **1. News Ingestion Agent** | Ingests approved RSS feeds; cleans HTML; generates deterministic SHA-256 URL hashes for idempotent storage. | `feedparser`, `beautifulsoup4` |
| **2. Deduplication Agent** | Converts text into vectors; compares candidate articles within a 48-hour window; clusters multi-source duplicates ($\text{sim} \ge 0.80$). | TF-IDF / Cosine Similarity |
| **3. Entity Extraction Agent** | Detects companies, regulators (RBI, SEBI), and sectors. Fuzzy matches against Nifty 50 reference master; rejects unverified tickers. | `RapidFuzz`, `spaCy` |
| **4. Impact Mapping Agent** | Evaluates direction (Positive, Negative, Neutral) per company; assigns confidence score; extracts exact verbatim evidence sentence. | Contextual heuristics & Ollama fallback |
| **5. Storage Agent** | Commits clustered stories, entity associations, impact assessments, and audit logs with foreign key integrity. | `SQLite3` (WAL Mode) |
| **6. Vector Indexing Agent** | Maintains local vector index for stories and sentences to support natural language semantic retrieval. | `scikit-learn`, `FAISS` |

---

## 📐 Impact-Aware Multi-Factor Ranking Formula

When a user submits a natural-language query, stories are retrieved and ordered by:

$$\text{Final Score} = 0.40 \times \text{Similarity} + 0.20 \times \text{Entity Match} + 0.20 \times \text{Recency} + 0.20 \times \text{Impact Confidence}$$

- **Semantic Similarity ($S$):** Cosine similarity between query and story vector.
- **Entity Match ($E$):** $1.0$ if query explicitly cites a tagged company/ticker; $0.8$ if matching sector; $0.0$ otherwise.
- **Recency ($R$):** $R = \frac{1}{1 + \Delta t_{\text{days}}}$.
- **Impact Confidence ($C$):** Calibrated score based on headline presence ($0.35$), mention frequency ($0.15$), event keywords ($0.25$), and exact name match ($0.25$).

---

## 🚀 One-Click Windows Execution (Turnkey Demonstration)

The project includes batch launchers designed for simple laptop demonstration without manual terminal commands.

### First-Time Setup (Run Once)
Double-click:
```bat
SETUP_MARKETPULSE.bat
```
*Creates the virtual environment (`venv`), installs all dependencies, initializes the SQLite database, and pre-seeds the verified Nifty 50 master and benchmark dataset.*

### Starting MarketPulse
Double-click:
```bat
START_MARKETPULSE.bat
```
*Activates the environment, verifies port availability, starts the FastAPI backend (port 8000), launches the Streamlit frontend (port 8501), and opens your default browser automatically.*

### Stopping MarketPulse
Double-click:
```bat
STOP_MARKETPULSE.bat
```
*Safely closes only MarketPulse processes on ports 8000 and 8501 without terminating unrelated Python scripts.*

---

## 💻 Manual CLI Execution (Alternative)

```powershell
# 1. Activate virtual environment
.\venv\Scripts\activate

# 2. Run test suite
pytest tests/ -v

# 3. Launch unified application
python app.py
```

---

## 📊 Streamlit Dark Fintech Dashboard (7 Pages)

1. **Executive Dashboard:** Live KPIs, articles ingested, unique stories formed, sentiment distribution pie chart, and sector activity breakdown.
2. **Live Financial News:** Chronological stream of financial bulletins with source badges and original article links.
3. **Story Intelligence:** Comprehensive story dossier with grouped duplicate sources and company impact cards.
4. **Company Intelligence:** Deep dive by Nifty 50 ticker with historical impact timeline and verbatim evidence quotes.
5. **AI Natural Language Search:** Natural language search bar with real-time multi-factor ranking and score breakdown.
6. **Analytics & Baselines:** Quantitative metrics comparing MarketPulse methods against simpler classical baselines.
7. **About & Viva Methodology:** Academic documentation, DTU team attribution, ranking equations, and viva defense guidelines.

---

## 🧪 Quantitative Academic Evaluation

Measured on hand-labelled Indian financial news test sets:

| Task / Subsystem | MarketPulse Technique | Classical Baseline | MarketPulse Result | Baseline Result | Delta |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Entity Extraction (NER)** | RapidFuzz + Nifty 50 Master | Exact String Match | **93.0% F1** | 74.6% F1 | **+18.4%** |
| **Deduplication** | Centroid Cosine Clustering | TF-IDF Keyword Match | **90.2% F1** | 66.1% F1 | **+24.1%** |
| **Impact Classification** | Context Evidence Mapping | Word-List Sentiment | **87.0% Accuracy** | 58.0% Accuracy | **+29.0%** |
| **Search & Ranking** | Multi-Factor Formula | Newest-First Ordering | **0.85 P@5** | 0.52 P@5 | **+0.33** |
| **Evidence Grounding** | Verbatim Sentence Validation | Top-2 Sentence Fallback | **96.5% Grounded** | 71.0% Grounded | **+25.5%** |

---

## 📁 Repository Structure

```
marketpulse/
├── app.py                      # Main unified application launcher
├── SETUP_MARKETPULSE.bat       # Windows 1-click first-time setup
├── START_MARKETPULSE.bat       # Windows 1-click application start
├── STOP_MARKETPULSE.bat        # Windows 1-click safe process shutdown
├── requirements.txt            # Pinned Python dependencies
├── .env.example                # Example environment configuration
├── .gitignore                  # Git exclusion rules
├── README.md                   # Complete documentation & viva guide
│
├── agents/                     # The Six Autonomous Python Agents
│   ├── ingestion_agent.py      # Agent 1: Feed parsing & cleaning
│   ├── deduplication_agent.py  # Agent 2: Cosine clustering & stories
│   ├── entity_agent.py         # Agent 3: NER & Nifty 50 linking
│   ├── impact_agent.py         # Agent 4: Sentiment & evidence extraction
│   ├── storage_agent.py        # Agent 5: Relational SQLite persistence
│   └── vector_agent.py         # Agent 6: Vector indexing & search
│
├── orchestration/              # LangGraph Graph Coordination
│   ├── state.py                # Typed pipeline state dictionary
│   └── graph.py                # 6-agent sequential graph orchestrator
│
├── database/                   # SQLite Relational Persistence
│   ├── connection.py           # SQLite WAL connection manager
│   ├── models.py               # DDL schemas & indexes
│   └── repository.py           # Relational queries and CRUD methods
│
├── services/                   # Business & Ranking Services
│   ├── ranking_service.py      # Multi-factor ranking engine
│   └── search_service.py       # Semantic intelligence search service
│
├── api/                        # FastAPI REST Backend
│   └── main.py                 # REST API endpoints (Port 8000)
│
├── assets/                     # Local Visual & UI Assets (100% Offline)
│   ├── images/                 # Financial district & regulatory facade images
│   │   ├── mumbai_financial_district.jpg
│   │   ├── rbi_headquarters.jpg
│   │   └── corporate_district.jpg
│   └── icons/                  # Local SVG/PNG category icons
│
├── frontend/                   # Streamlit Fintech Dashboard
│   ├── app.py                  # 7-page institutional dark UI (Port 8501)
│   ├── styles/
│   │   └── theme.py            # Futuristic Neon Blue & Neon Green theme
│   └── utils/
│       └── assets.py           # Base64 local image asset encoder & fallback
│
├── data/                       # Verified Reference Masters & Benchmarks
│   ├── company_master.csv      # Nifty 50 companies with aliases
│   ├── regulators.csv          # Indian regulators (RBI, SEBI, etc.)
│   ├── sector_keywords.csv     # Industry domain keywords
│   ├── feeds.json              # Configured Indian financial feeds
│   └── demo/
│       └── frozen_articles.json# Verified Indian news benchmark dataset
│
└── tests/                      # Automated Test Suite (Pytest)
    ├── test_ingestion.py       # Agent 1 & Cleaner tests
    └── test_agents.py          # Agents 2-6, Ranking & Pipeline tests
```

---

## 🖼️ Local Visual Assets & Licensing

All visual assets required by MarketPulse are stored entirely locally within `assets/images/` to ensure 100% offline autonomy without external CDN or hotlink dependencies:
- `mumbai_financial_district.jpg`: Authentic Bombay Stock Exchange (BSE) Phiroze Jeejeebhoy Towers with the digital ticker band on Dalal Street, Mumbai.
- `rbi_headquarters.jpg`: Official Reserve Bank of India (RBI) seal emblem on the stone facade for banking and regulatory stories.
- `corporate_district.jpg`: Modern glass corporate skyscrapers representing industry constituents and corporate releases.

**Licensing & Offline Fallback:**
- All image assets are self-contained locally for academic research and viva demonstration under DTU Capstone Group A5.
- Embedded via `frontend/utils/assets.py` using Base64 Data URIs (`data:image/jpeg;base64,...`) with automatic inline SVG gradient fallbacks to prevent broken image icons under any execution environment.

---

## 🔒 Security, Privacy & Zero-Cost Compliance

- **Zero API Costs:** Built entirely using open-source Python libraries with local execution.
- **No Private Keys in Git:** `.gitignore` excludes virtual environments, local database WAL journals, cache files, and `.env` overrides.
- **Offline Reliability:** Demonstrates smoothly in lecture halls and viva evaluation rooms with zero network dependency.
