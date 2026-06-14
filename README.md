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

### 2. Clone & Set Up Git Hooks

```bash
git clone https://github.com/VIKRAM-CHOUDHARY-01/GenFly.git
cd GenFly
sh .githooks/setup.sh
```

The setup script points Git at `.githooks/` and makes the hooks executable. This enforces branch naming and commit message conventions automatically — **run it once after cloning**.

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

### 4. Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Production-ready code only |
| `feature/01/flightSearch` | Feature branches |
| `fix/42/otpTimerReset` | Bug-fix branches |
| `refactor/07/bookingRepository` | Refactor branches |

Format: `type/number/camelCaseTitle`
Allowed types: `feature`, `fix`, `refactor`, `chore`, `docs`, `test`

Always create a feature branch. Never push directly to `main`.

```bash
git checkout -b feature/01/flightSearch
```

---

### 5. Commit Message Convention

Format: `#type : short description`

```
#feature : add flight search screen
#fix : resolve OTP timer reset bug
#refactor : extract booking repository
#chore : update flutter dependencies
```

Both conventions are enforced by Git hooks (set up in step 2).

---

### 6. PR Rules

- PRs must be reviewed by at least one other developer before merging
- `main` branch = production-ready only

---

## Questions?

Contact the project lead or open an issue on GitHub.
