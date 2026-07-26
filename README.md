# Life OS

> A premium, gamified personal operating system — not a to-do list.
> Life OS helps you manage every area of your life (fitness, learning,
> career, finance, relationships, mental health, spirituality, fun) in
> one interactive, visually engaging dashboard built around
> **Goals → Systems → Daily Actions → Progress**.

Status: 🚧 **Early development.** This repo is being built milestone by
milestone (see [Roadmap](#roadmap)). The current milestone implements the
project foundation, design system, and a fully interactive Dashboard.

---

## ✨ Features

### Implemented
- **Design system** — dark-mode-first theme, glassmorphism cards,
  gradient accents, typography and spacing tokens.
- **Dashboard** — live greeting, animated circular progress ring,
  interactive "Today" action list with tap-to-complete and instant
  progress/XP recalculation.

### Planned (see Roadmap)
- Life Areas with per-area progress, XP, and streaks
- Goals system with auto-linked systems and dependency graphs
- Interactive drag-and-drop daily timeline
- XP & Level system, achievements
- GitHub-style heatmap (workout / study / habits / sleep / mood)
- Life Balance radar chart
- Mood tracking with pattern insights
- Proactive AI assistant
- Statistics (weekly / monthly / yearly) with trends
- Smart, non-intrusive notifications
- Habits, Calendar, Universal Search, Notes (markdown), Finance,
  Health, Reading, Learning, Projects modules
- Customizable dashboard widgets
- Supabase-backed sync with offline-first local cache

---

## 🏗 Architecture

Life OS follows **Clean Architecture** with a **feature-first** folder
structure so each life area (dashboard, goals, habits, …) is a
self-contained module with its own data/domain/presentation layers.

```
lib/
├── core/                # App-wide concerns
│   ├── theme/            # Colors, typography, spacing, ThemeData
│   ├── constants/
│   ├── router/
│   ├── utils/
│   └── errors/
├── features/
│   ├── dashboard/
│   │   ├── data/          # Repositories (local now, Supabase later)
│   │   ├── domain/        # Entities (e.g. DailyAction)
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/ # Riverpod state
│   ├── goals/
│   ├── habits/
│   ├── areas/
│   └── xp/
├── shared/
│   ├── widgets/           # GlassCard, AnimatedProgressRing, …
│   └── models/
├── services/              # Cross-feature services (Supabase, notifications, …)
└── main.dart
```

**Principles applied:**
- SOLID principles, Repository Pattern, dependency injection via Riverpod providers
- Presentation layer never talks to a data source directly — always through
  a repository interface (see `DailyActionsRepository`), so swapping the
  local implementation for a Supabase-backed one won't touch any UI code
- Offline-first: local repositories today, Hive cache + Supabase sync in
  an upcoming milestone, behind the same interfaces
- Unit-test-friendly: business logic lives in providers/repositories, not
  widgets, so it can be tested without pumping a widget tree

---

## 🧰 Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart ≥ 3.3) |
| State management | Riverpod (`flutter_riverpod`, code-gen ready) |
| Backend | Supabase (auth, Postgres, realtime) |
| Local cache | Hive |
| Routing | go_router |
| Animations | flutter_animate, custom `CustomPainter` (progress ring) |
| Charts | fl_chart |
| Typography | Google Fonts (Inter + Lexend) |

---

## 🚀 Installation

> Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel).

```bash
# Clone the repo
git clone https://github.com/<your-username>/life-os.git
cd life-os

# Install dependencies
flutter pub get

# Run code generation (Freezed / JSON / Riverpod / Hive)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment
Supabase credentials will be required once the Supabase-sync milestone
lands. These will be read from a local `.env` file (already gitignored)
— never commit real keys.

---

## 📸 Screenshots

_Coming soon — screenshots will be added as each screen is completed._

---

## 🗺 Roadmap

Development proceeds milestone by milestone, each with its own commit:

- [x] Initial project setup
- [x] Design System
- [x] Dashboard
- [ ] Life Areas
- [ ] Goals Module
- [ ] Habits Module
- [ ] Daily Timeline (drag & drop)
- [ ] XP & Level System
- [ ] Achievements
- [ ] Heatmap
- [ ] Life Balance Wheel
- [ ] Mood Tracking
- [ ] AI Assistant
- [ ] Statistics
- [ ] Smart Notifications
- [ ] Calendar
- [ ] Universal Search
- [ ] Notes (markdown)
- [ ] Finance
- [ ] Health
- [ ] Reading
- [ ] Learning
- [ ] Projects
- [ ] Customizable Widgets
- [ ] Supabase Sync (offline-first)
- [ ] Settings
- [ ] Bug Fixes / UI Polish

---

## 📄 License

Released under the [MIT License](LICENSE).
