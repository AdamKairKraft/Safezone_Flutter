# SafeZone Flutter

Offline-first tablet client for SafeZone — site safety & compliance tracking (incident
reports, toolbox talks, SHE files, compliance tracking, roles & responsibilities) across
industries (construction, food safety, aviation, fire safety, first aid). Built for a
site supervisor who needs to keep drafting reports with no signal and have them sync
automatically once connectivity returns.

Talks to the [`safezone-backend`](https://github.com/AdamKairKraft/Safezone_Backend)
Spring Boot API. This repo has no backend of its own — you need that project running
locally (or pointed at a deployed instance) for anything here to actually load data.

## Prerequisites

- **Flutter 3.47.1** (stable channel) — matches CI (`.github/workflows/ci.yml`) and the
  Dart SDK constraint in `pubspec.yaml`. Check with `flutter --version`.
- A running instance of `safezone-backend` — see that repo's README. Quick version:
  ```bash
  cd ../safezone-backend
  ./start.sh   # starts Postgres + the backend on http://localhost:8080, with demo data
  ```
- An emulator/simulator/device, or a desktop/web target (`flutter devices` to list what's
  available).

## Setup

```bash
flutter pub get
```

## Running locally

```bash
flutter run
```

The API base URL defaults to `http://localhost:8080`, except on the **Android
emulator**, which can't reach the host machine via `localhost` — it automatically uses
`http://10.0.2.2:8080` instead (see `lib/network/api_config.dart`). Override either with:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8080
```

With the backend up and seeded (`./start.sh` loads demo data automatically), log in with
any of the demo accounts — password is the same for all of them:

| Email | Password |
|---|---|
| jane.smith@acme-construction.test | `SafeZone123!` |
| tom.reid@acme-construction.test | `SafeZone123!` |
| lindiwe.mokoena@acme-construction.test | `SafeZone123!` |
| priya.naidoo@skylinefoods.test | `SafeZone123!` |
| carlos.mendes@skylinefoods.test | `SafeZone123!` |
| anna.petrova@skylinefoods.test | `SafeZone123!` |

(Full list and details in `safezone-backend/README.md` under "Demo credentials".)

## Architecture

- **State/data layer**: Riverpod (`lib/providers/`).
- **Local database**: `drift` (sqlite, `lib/local_db/`) — caches reports (with a
  dirty/pending-sync flag and local `baseVersion`), a mutation outbox, report-type
  definitions (`formSchema` as JSON, cached aggressively since the Report Builder must
  render fully offline), and read-only reference data (sites, industry modules, roles
  catalog, compliance status, SHE files) refreshed opportunistically when online. The
  generated `database.g.dart` is committed — no `build_runner` step needed to build or
  run.
- **HTTP**: `dio` (`lib/network/api_client.dart`), with an interceptor that attaches the
  bearer token and silently retries once via `/api/auth/refresh` on a 401.
- **Secure storage**: `flutter_secure_storage` for the refresh token
  (`lib/storage/secure_storage.dart`). Access tokens live in memory only.
- **Connectivity**: `connectivity_plus` triggers a push-then-pull sync cycle
  automatically on reconnect; a persistent indicator (`lib/widgets/sync_status_indicator.dart`)
  always shows online/offline + pending-changes state — sync status is never hidden from
  the user.
- **IDs**: `uuid` for client-generated report/mutation ids — the backend's id columns are
  caller-assigned specifically so offline drafting can create real ids before ever
  reaching the server.

### Offline sync protocol

Only `report` is a syncable entity today (SHE files and compliance requirements are
cache-and-view only, no offline editing). `SyncService` (`lib/repositories/sync_service.dart`)
batches every queued outbox mutation into one `POST /api/sync/push` on reconnect, then
`GET /api/sync/pull?since=<cursor>` for anything newer. A push that comes back
`CONFLICT` (last-write-wins already applied server-side, but recoverable) surfaces via
`GET /api/conflicts` for the user to resolve.

**Submitting** a report (`DRAFT` → `SUBMITTED`) is deliberately *not* part of the sync
queue — it's an online-only action. The Report Builder disables "Submit for review"
while offline rather than queuing it, so a user is never misled into thinking an offline
submit went through; the draft itself keeps saving locally either way.

## Project layout

```
lib/
  local_db/     drift schema and generated database (tables.dart, database.dart/.g.dart)
  models/       Data classes mirroring the backend's DTOs
  network/      API client, base URL resolution, auth session (token refresh)
  providers/    Riverpod providers (auth, connectivity, reference data, reports, sync)
  repositories/ Auth, reference data, reports, and sync orchestration
  screens/      One screen per route (Dashboard, Roles, Reporting, Report Builder, SHE
                Files, Compliance, Settings) + Login
  storage/      Secure storage wrapper for the refresh token
  theme/        App theme, matching the wireframe's color palette
  widgets/      Shared UI (cards, pills, progress bar, dynamic form field, sync indicator)
```

Report forms are **dynamic**: the Report Builder renders its fields from whatever
`formSchema` the backend returns for the selected report type
(`GET /api/industry-modules/{code}/report-types`), rather than hardcoding a form per type
— matching `safezone-web`'s approach.

## Running tests

```bash
flutter analyze
flutter test
```

CI (`.github/workflows/ci.yml`) runs both on every push/PR to `dev`.

## Known gaps (backend limitations, not bugs here)

- SHE file "upload" registers file **metadata** only — the backend doesn't yet expose a
  real binary storage endpoint (presigned URL or otherwise), so no file content is
  actually stored.
- Sites/organizations have no formal "industry module" foreign key in the backend yet.
- Only `report` is offline-sync-enabled on the backend today, matching this app's scope.

## Branching & contributing

Mirrors `safezone-backend`'s convention: `dev` is the only permanent branch, protected —
every change lands via a pull request requiring **2 approvals** and a passing CI build
(`.github/workflows/ci.yml`: analyze, test), no direct pushes. Branch off `dev`, name your
branch `<your-name>/<type>/<short-description>` (`type` is `bug`, `task`, or `refactor`),
open a PR back into `dev`. Merged branches are deleted automatically.
