# GenFly — Flight Ticket Booking Platform

Production-grade flight booking Android app built with Flutter, targeting 100,000+ users.

---

## For New Developers — Start Here

### 1. Prerequisites

Install these in order:

| Tool | Download |
|---|---|
| Git | https://git-scm.com |
| VS Code | https://code.visualstudio.com |
| Flutter SDK (stable) | https://docs.flutter.dev/get-started/install/windows |
| JDK 17 (Temurin) | https://adoptium.net |
| Android Studio (SDK only) | https://developer.android.com/studio |

**VS Code Extensions to install:**
- Flutter
- Dart
- Pubspec Assist

**Verify Flutter is working:**
```bash
flutter doctor
```
All items must be green before proceeding.

---

### 2. Clone the Repository

```bash
git clone https://github.com/VIKRAM-CHOUDHARY-01/GenFly.git
cd GenFly
```

---

### 3. Install Claude Code

Claude Code is the AI assistant used by this team. It reads `CLAUDE.md` automatically and gives every developer the same project context.

**Install Claude Code:**
```bash
npm install -g @anthropic-ai/claude-code
```

**Start Claude Code inside the project:**
```bash
cd GenFly
claude
```

Claude will automatically load `CLAUDE.md` from the project root — no manual setup needed. Your Claude session will have full context of the architecture, tech stack, standards, and domain scope.

---

### 4. Install Flutter Dependencies

```bash
flutter pub get
```

---

### 5. Firebase Setup

This project uses Firebase. You need the `google-services.json` file — **this is not in the repo for security reasons.**

- Ask the project lead to share it with you
- Place it at: `android/app/google-services.json`
- Never commit this file (it is already in `.gitignore`)

---

### 6. Environment Variables

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Ask the project lead for API keys. Never commit `.env`.

---

### 7. Run the App

Connect your Android phone via USB and enable USB Debugging, then:

```bash
flutter run
```

> **Note:** Prefer a real device over an emulator — emulators are slow on 8GB RAM machines.

---

### 8. Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Production-ready code only |
| `feature/auth` | Auth module |
| `feature/search` | Flight search |
| `feature/booking` | Booking flow |
| `feature/payment` | Payment integration |

Always create a feature branch. Never push directly to `main`.

```bash
git checkout -b feature/your-feature-name
```

---

### 9. Commit Message Convention

```
feat: add flight search screen
fix: resolve OTP timer reset bug
refactor: extract booking repository
chore: update flutter dependencies
```

---

### 10. PR Rules

- PRs must be reviewed by at least one other developer before merging
- All tests must pass before merging
- `main` branch = production-ready only

---

## Project Structure

```
lib/
├── core/                  # Shared utilities, theme, constants, errors
├── features/
│   ├── auth/
│   │   ├── data/          # API, models, repository implementations
│   │   ├── domain/        # Entities, use cases, repository interfaces
│   │   └── presentation/  # BLoC, screens, widgets
│   ├── search/
│   ├── booking/
│   ├── payment/
│   ├── ticket/
│   ├── profile/
│   └── notifications/
└── main.dart
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Dart |
| Framework | Flutter (Material 3) |
| Architecture | Clean Architecture + BLoC |
| State Management | flutter_bloc |
| Navigation | GoRouter |
| Networking | Dio |
| Auth | Firebase Auth |
| Notifications | Firebase FCM |
| Payment | Razorpay |

---

## Questions?

Contact the project lead or open an issue on GitHub.
