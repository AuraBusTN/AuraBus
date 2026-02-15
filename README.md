# 🚌 AuraBus

<p align="center">
  <img src="frontend/assets/images/app_logo.png" alt="AuraBus Logo" width="120" />
</p>

<p align="center">
  <strong>A smarter way to move around Trentino</strong>
</p>

<p align="center">
  <a href="#-features">Features</a> &bull;
  <a href="#-tech-stack">Tech Stack</a> &bull;
  <a href="#-architecture">Architecture</a> &bull;
  <a href="#-getting-started">Getting Started</a> &bull;
  <a href="#-api-documentation">API Docs</a> &bull;
  <a href="#-testing">Testing</a> &bull;
  <a href="#-license">License</a>
</p>

---

**AuraBus** is a full-stack application designed to improve the public transport experience in the Trentino region. It provides real-time bus tracking, estimated passenger occupancy, predictive delay analytics powered by machine learning, and a gamified ranking system — all in a modern, multilingual mobile and web interface.

> 📚 University project inspired by *Trentino Trasporti*.

---

## ✨ Features

| Category | Description |
|----------|-------------|
| 🗺️ **Live Map** | Interactive Google Maps view with real-time bus positions and stop markers |
| 🕒 **Real-Time Tracking** | Live bus positions ingested every minute from the Trentino Trasporti API |
| 👥 **Occupancy Estimation** | Simulated passenger load levels for each active bus |
| 🤖 **Delay Prediction** | XGBoost-based ML model predicting arrival delays per stop, retrained weekly |
| 🎫 **Digital Tickets** | In-app ticket display with QR codes |
| 🏆 **Leaderboard** | Gamified ranking system for active users |
| ⭐ **Favorite Routes** | Save and quickly access frequently used routes |
| 🔐 **Authentication** | Email/password and Google Sign-In support |
| 🌍 **Multilingual** | Full English and Italian localization |
| 📱 **Cross-Platform** | Android, iOS, and Web support |

---

## 🧩 Tech Stack

### Frontend

| Technology | Purpose |
|------------|---------|
| **Flutter** (Dart ≥ 3.9.2) | Cross-platform UI framework |
| **Riverpod** | Reactive state management |
| **GoRouter** | Declarative navigation with auth-aware redirects |
| **Google Maps Flutter** | Interactive map rendering |
| **Dio** | HTTP client |
| **Geolocator** | Device location services |
| **Google Sign-In** | OAuth authentication |
| **Flutter Secure Storage** | Secure token persistence |
| **Skeletonizer** | Loading skeleton placeholders |
| **Material 3** | Modern design system with custom theming |

### Backend

| Technology | Purpose |
|------------|---------|
| **Node.js** + **Express 5** | REST API server |
| **MongoDB** + **Mongoose** | Primary database & ODM |
| **Redis** | Response caching layer |
| **JWT** + **bcryptjs** | Authentication & password hashing |
| **Google Auth Library** | Server-side Google OAuth verification |
| **Helmet / CORS / HPP** | Security middleware stack |
| **Express Rate Limit** | Request rate limiting |
| **Swagger (OpenAPI 3.0)** | Interactive API documentation |
| **node-cron** | Scheduled data ingestion (every minute) |
| **Jest** + **Supertest** | Unit & integration testing |

### AI Service

| Technology | Purpose |
|------------|---------|
| **Python** (FastAPI + Uvicorn) | ML prediction microservice |
| **XGBoost** | Gradient-boosted regression for delay prediction |
| **scikit-learn** + **Pandas** | Data preprocessing & feature engineering |
| **APScheduler** | Automated weekly model retraining |
| **PyMongo** | Direct MongoDB access for training data |

### Infrastructure

| Technology | Purpose |
|------------|---------|
| **Docker** + **Docker Compose** | Container orchestration |
| **MongoDB** (container) | Persistent database with named volumes |
| **Redis Alpine** (container) | Password-protected cache with persistence |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Frontend                     │
│              (Android / iOS / Web)                      │
│     Riverpod · GoRouter · Google Maps · Dio             │
└──────────────────────┬──────────────────────────────────┘
                       │ REST API (HTTP)
                       ▼
┌──────────────────────────────────────────────────────────┐
│                 Node.js / Express 5 API                  │
│        Port 8888 · JWT Auth · Rate Limiting              │
│                                                          │
│  /auth    /stops    /routes    /users                    │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │  Ingestion   │  │    Cache     │  │   Swagger UI   │  │
│  │  Cron (1min) │  │  Middleware  │  │   /api-docs    │  │
│  └──────────────┘  └──────────────┘  └────────────────┘  │
└─────┬────────────────────┬───────────────────┬───────────┘
      │                    │                   │
      ▼                    ▼                   ▼
┌────────────┐     ┌─────────────┐    ┌────────────────────┐
│  MongoDB   │     │    Redis    │    │   AI Service       │
│  :27017    │     │    :6379    │    │   FastAPI :8000    │
│            │     │             │    │   XGBoost Model    │
│ Users      │     │  Stop Cache │    │   POST /predict    │
│ Buses      │     │  Route Cache│    │   Weekly Retrain   │
│ TripMetrics│     └─────────────┘    └────────────────────┘
└────────────┘
```

### Data Models

| Model | Description |
|-------|-------------|
| **User** | Accounts with local or Google auth, profile info, favorite routes, points & ranking |
| **Bus** | Vehicle registry with type classification (mini, standard, articulated) |
| **TripMetric** | Time-series trip data (route, stop, delay, timestamps) with 60-day TTL |

---

## 🚀 Getting Started

### Prerequisites

- **Docker** & **Docker Compose**
- **Node.js** ≥ 25 (for local development without Docker)
- **Flutter SDK** ≥ 3.9.2
- **Python** ≥ 3.14 (for AI service local development)

### 1. Clone the Repository

```bash
git clone https://github.com/AuraBusTN/AuraBus.git
cd AuraBus
```

### 2. Backend Setup

#### Option A: Docker (Recommended)

```bash
cd backend

# Configure environment variables
cp .env.example .env
# Edit .env with your values (MongoDB credentials, JWT secrets, API keys, etc.)

# Start all services (API, MongoDB, Redis, AI Service)
docker compose up --build
```

This starts four containers:

| Service | Container | Port |
|---------|-----------|------|
| API Server | `aurabus_api` | `8888` |
| MongoDB | `aurabus_mongo_db` | `27017` |
| Redis | `aurabus_redis` | `6379` |
| AI Service | `aurabus-ai` | `8000` |

#### Option B: Local Development

```bash
cd backend

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your configuration

# Start in development mode (with hot-reload)
npm run dev
```

#### Environment Variables (Backend)

| Variable | Description |
|----------|-------------|
| `MONGO_URI` | MongoDB connection string |
| `MONGO_USER` | MongoDB username |
| `MONGO_PASSWORD` | MongoDB password |
| `JWT_SECRET` | JWT signing secret |
| `REFRESH_SECRET` | Refresh token secret |
| `GOOGLE_AUTH_CLIENT_ID` | Google OAuth Client ID |
| `API_URL` | Trentino Trasporti external API URL |
| `API_USER` | External API username |
| `API_PASSWORD` | External API password |
| `PREDICTION_URL` | AI prediction service URL |
| `REDIS_HOST` | Redis host |
| `REDIS_PORT` | Redis port |
| `REDIS_PASSWORD` | Redis password |
| `NODE_ENV` | Environment (`development` / `production`) |

### 3. Frontend Setup

```bash
cd frontend

# Configure environment
cp assets/env/.env.example assets/env/.env
# Set API_URL (e.g., http://localhost:8888)

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run on a connected device or emulator
flutter run
```

#### Supported Platforms

```bash
flutter run -d chrome     # Web
flutter run -d android    # Android
flutter run -d ios        # iOS
```

---

## 📖 API Documentation

Interactive Swagger UI is available when the backend is running:

```
http://localhost:8888/api-docs
```

### API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/auth/register` | — | Register a new account |
| `POST` | `/auth/login` | — | Login with email/password |
| `POST` | `/auth/google` | — | Login with Google |
| `POST` | `/auth/refresh-token` | — | Refresh access token |
| `POST` | `/auth/logout` | — | Logout |
| `GET`  | `/auth/me` | 🔒 | Get current user profile |
| `GET`  | `/stops/:id` | — | Get stop info (cached 60s) |
| `GET`  | `/routes/` | — | Get all routes (cached 24h) |
| `GET`  | `/users/leaderboard` | 🔒 | Get user rankings |
| `GET`  | `/users/favorite-routes` | 🔒 | Get saved routes |
| `POST` | `/users/favorite-routes` | 🔒 | Save a favorite route |

### AI Prediction Endpoint

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/predict` | Predict delay per stop for a trip |

**Request body:**

```json
{
  "route": "string",
  "current_delay": 120,
  "stops": [
    {
      "stop_encoded": 42,
      "hour": 8,
      "day_of_week": 1,
      "directionId": 0
    }
  ]
}
```

---

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
npm test

# Run with watch mode
npm run test:watch

# Run with coverage report
npm run test:coverage
```

**Coverage thresholds:** 80% lines / functions / statements, 60% branches.

Test suites cover authentication, routes, stops, user controllers, favorite routes, leaderboard, and occupancy simulation.

### Frontend Tests

```bash
cd frontend

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

```

Test suites cover theming, widgets, routing, localization, core utilities, and feature-level tests.

---

## 🌍 Localization

AuraBus supports **English** and **Italian**. Translations are managed via ARB files:

```
frontend/lib/l10n/
├── app_en.arb    # English (template)
└── app_it.arb    # Italian
```

To regenerate localization files after editing:

```bash
flutter gen-l10n
```

---

## 🔀 Development Workflow

The team follows **Git Flow**:

| Branch | Purpose |
|--------|---------|
| `main` | Stable, production-ready releases |
| `develop` | Active development integration |
| `feature/*` | New feature development |
| `fix/*` | Bug fixes |
| `hotfix/*` | Urgent fixes on `main` |

**Commit convention:** `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`

All changes go through **Pull Requests** with mandatory code review.

---

## 📁 Project Structure

```
AuraBus/
├── backend/
│   ├── src/
│   │   ├── controllers/      # Request handlers
│   │   ├── models/            # Mongoose schemas (User, Bus, TripMetric)
│   │   ├── routes/            # Express route definitions
│   │   ├── services/          # Business logic (Ingestion, Stops)
│   │   ├── middlewares/       # Auth, caching, rate limiting
│   │   ├── repositories/      # Data access layer
│   │   ├── config/            # DB, Redis, app configuration
│   │   ├── utils/             # Helpers & static data
│   │   └── loaders/           # DB connection & data seeding
│   ├── ai-service/            # Python ML microservice
│   │   ├── main.py            # FastAPI app with /predict endpoint
│   │   └── trainer.py         # XGBoost model training pipeline
│   ├── tests/                 # Jest test suites
│   ├── data/                  # Static JSON seed data
│   ├── docs/                  # OpenAPI schema components
│   └── docker-compose.yaml    # Multi-service orchestration
│
├── frontend/
│   ├── lib/
│   │   ├── features/          # Feature modules (Clean Architecture)
│   │   │   ├── auth/          # Authentication logic
│   │   │   ├── map/           # Live map & bus tracking
│   │   │   ├── tickets/       # Digital ticket display
│   │   │   ├── ranking/       # User leaderboard
│   │   │   ├── account/       # User profile management
│   │   │   └── ...
│   │   ├── core/              # Shared config, networking, services, utils
│   │   ├── common/            # Shared widgets & components
│   │   ├── routing/           # GoRouter configuration
│   │   └── l10n/              # Localization (EN, IT)
│   ├── test/                  # Flutter test suites
│   ├── assets/                # Images, env files, static data
│   └── web/                   # Web-specific assets
│   └── android/               # Android-specific assets
│   └── ios/                   # ios-specific assets
│
└── README.md
```

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**.
See the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ in Trentino
</p>
