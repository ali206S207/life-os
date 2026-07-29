# Life OS

> A premium, gamified personal operating system — not a to-do list.
> Life OS helps you manage every area of your life (fitness, learning,
> career, finance, relationships, mental health, spirituality, fun) in
> one interactive, visually engaging dashboard built around
> **Goals → Systems → Daily Actions → Progress**.

Status: 🚧 **Active development.** All UI/UX modules from the original
spec are implemented, and **Supabase Sync (Phase 1)** is live: real
email/password auth gates the app, and Goals + Habits persist to a
real Postgres database with owner-only Row Level Security. Remaining
modules (Notes, Projects, Finance, Health, ...) still run on local/mock
data behind the same repository interfaces — wiring each one to
Supabase is now a matter of writing one more `Supabase*Repository`
class per module, following the pattern already established for Goals
and Habits.

---

## ✨ Features

### Implemented
- **Design system** — dark-mode-first theme, glassmorphism cards,
  gradient accents, typography and spacing tokens.
- **Dashboard** — live greeting, animated circular progress ring,
  interactive "Today" action list, drag-and-drop **customizable
  widgets** (XP bar / Assistant / Progress ring / Today's actions).
- **Life Areas** — 8 core areas with progress, XP, level, streaks.
- **Goals** — auto-linked systems, weighted progress, radial dependency graph.
- **Habits** — streaks, best streak, difficulty, miss history.
- **XP & Level system** — cross-feature XP aggregation, animated XP bar.
- **Achievements** — unlock conditions derived live from habits/goals/level.
- **Statistics** — GitHub-style heatmap (6 switchable metrics), Life
  Balance radar chart, Mood tracking with pattern insights.
- **AI Assistant** — rule-based proactive suggestions from live app state.
- **Smart Notifications** — non-intrusive inbox, unread badge.
- **Reading, Learning, Projects, Finance, Health** modules.
- **Notes** — markdown editor with edit/preview toggle, tags.
- **Calendar** — month grid, agenda, drag-and-drop rescheduling.
- **Universal Search** — federated search across Goals/Habits/Notes/Projects/Books/Courses.
- **Settings** — live Dark/Light/System theme switching.
- **Responsive shell** — NavigationRail for desktop/PC, bottom nav + More hub for mobile.

### Planned
- **Supabase Sync (remaining modules)** — Notes, Projects, Finance,
  Health, Reading, Learning, Calendar, Life Areas, and Mood/Statistics
  still read local/mock data; Goals and Habits are the reference
  implementation for wiring the rest.
- Offline-first local cache (Hive) sitting in front of the Supabase
  repositories, for true offline support
- OS-level scheduled push notifications (`flutter_local_notifications`)
- Deep-linking individual search results to their exact item (currently
  routes to the parent module screen for Habits/Books/Courses/Projects)

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

### Backend
The app is wired to a real Supabase project. Connection details live in
`lib/core/config/supabase_config.dart` — the anon/publishable key is
safe to ship in client code by design (it's constrained entirely by
Row Level Security policies, unlike the secret `service_role` key,
which must never appear here). Life OS's tables are prefixed `lifeos_`
in the `public` schema, isolated by owner-only RLS from any other
tables in the same project.

---

## 📸 Screenshots

_Coming soon — screenshots will be added as each screen is completed._

---

## 🗺 Roadmap

Development proceeds milestone by milestone, each with its own commit:

- [x] Initial project setup
- [x] Design System
- [x] Dashboard
- [x] Life Areas
- [x] Goals Module
- [x] Habits Module
- [x] XP & Level System
- [x] Achievements
- [x] Heatmap
- [x] Life Balance Wheel
- [x] Mood Tracking
- [x] AI Assistant
- [x] Smart Notifications
- [x] Reading Module
- [x] Navigation Redesign (responsive: mobile + desktop/PC)
- [x] Finance Module
- [x] Health Module
- [x] Learning Module
- [x] Projects Module
- [x] Notes (markdown)
- [x] Universal Search
- [x] Settings
- [x] Customizable Widgets
- [x] Calendar (drag & drop)
- [x] Supabase Sync — Phase 1 (auth + Goals + Habits)
- [ ] Supabase Sync — remaining modules
- [ ] Offline-first local cache (Hive)
- [ ] OS-level scheduled push notifications
- [ ] Bug Fixes / UI Polish

---

## 📄 License

Released under the [MIT License](LICENSE).
