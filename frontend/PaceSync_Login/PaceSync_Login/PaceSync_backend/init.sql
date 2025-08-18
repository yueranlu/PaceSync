-- init.sql
-- We use gen_random_uuid() for primary keys so the DB can assign IDs automatically.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1) USERS: a lightweight cache of Firebase users (no passwords here).
--    Keyed by firebase_uid, which you get from Firebase ID token verification on the server.
CREATE TABLE IF NOT EXISTS users (
  firebase_uid TEXT PRIMARY KEY,           -- The stable UID from Firebase Auth (decoded["uid"])
  display_name VARCHAR(100),               -- Optional: cache display name for joins/UI
  email VARCHAR(150),                      -- Optional: cache email for joins/UI
  photo_url TEXT,                          -- Optional: profile photo URL
  created_at TIMESTAMPTZ DEFAULT NOW()     -- Timestamp when we first saw this user on the server
);

-- 2) RUNS: one row per running session ("room" runners join).
CREATE TABLE IF NOT EXISTS runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Server-side unique ID for the run
  session_code VARCHAR(10) UNIQUE,               -- Optional short join code for human-friendly sharing
  status VARCHAR(20) NOT NULL DEFAULT 'waiting', -- waiting | active | paused | finished | canceled
  started_at TIMESTAMPTZ,                        -- When the run actually starts
  ended_at TIMESTAMPTZ,                          -- When the run ends
  created_at TIMESTAMPTZ DEFAULT NOW(),          -- Row creation time
  updated_at TIMESTAMPTZ DEFAULT NOW()           -- Auto-updated via trigger below on any update
);

-- 3) RUN PARTICIPANTS: links users to a run and stores their summary stats.
CREATE TABLE IF NOT EXISTS run_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Unique row ID for the participant record
  run_id UUID NOT NULL REFERENCES runs(id) ON DELETE CASCADE,       -- Which run
  firebase_uid TEXT NOT NULL REFERENCES users(firebase_uid) ON DELETE CASCADE, -- Which Firebase user
  joined_at TIMESTAMPTZ DEFAULT NOW(),                               -- When they joined the run
  left_at TIMESTAMPTZ,                                               -- When they left (if they did)

  -- End-of-run summaries (store integers for easier math & indexing)
  total_distance_m INTEGER,                 -- Total distance in METERS (e.g., 5230)
  avg_pace_s_per_km INTEGER,               -- Average pace in SECONDS PER KM (e.g., 330 = 5:30/km)
  total_steps INTEGER,                      -- Optional: steps count

  CONSTRAINT uq_participant_per_run UNIQUE (run_id, firebase_uid) -- Prevent same user joining the same run twice
);

-- 4) LOCATIONS: append-only stream of GPS points while a run is active.
CREATE TABLE IF NOT EXISTS locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Unique ID for each tick
  run_id UUID NOT NULL REFERENCES runs(id) ON DELETE CASCADE,      -- Which run this tick belongs to
  firebase_uid TEXT NOT NULL REFERENCES users(firebase_uid) ON DELETE CASCADE, -- Which user sent the tick

  -- Coordinates & sensor data
  latitude  DECIMAL(9,6) NOT NULL,             -- Latitude with micro-degree precision (~0.11 m)
  longitude DECIMAL(9,6) NOT NULL,             -- Longitude with micro-degree precision
  altitude  REAL,                               -- Optional: meters above sea level
  accuracy  REAL,                               -- Optional: reported accuracy in meters
  speed_m_s REAL,                               -- Optional: speed in meters/second

  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- When the point was recorded by the device/server
  created_at TIMESTAMPTZ DEFAULT NOW()          -- When we inserted it into the DB
);

-- ===== Indexes to keep common queries fast =====

-- Filter/sort runs by status quickly (e.g., show "active" runs).
CREATE INDEX IF NOT EXISTS idx_runs_status
  ON runs(status);

-- Quickly find a participant row for a given run & user (enforces uniqueness too via constraint).
CREATE INDEX IF NOT EXISTS idx_participants_lookup
  ON run_participants(run_id, firebase_uid);

-- Fast "latest point per user in a run" queries:
-- you filter by (run_id, firebase_uid) and order by timestamp DESC LIMIT 1.
CREATE INDEX IF NOT EXISTS idx_locations_lookup
  ON locations(run_id, firebase_uid, timestamp);

-- ===== Trigger to keep runs.updated_at fresh =====

-- Define a tiny function that stamps updated_at to NOW() before each row update.
CREATE OR REPLACE FUNCTION touch_runs_updated_at() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Make sure there's no old trigger with the same name,
-- then create a trigger that runs our function before any UPDATE to runs.
DROP TRIGGER IF EXISTS trg_runs_touch_updated ON runs;
CREATE TRIGGER trg_runs_touch_updated
BEFORE UPDATE ON runs
FOR EACH ROW
EXECUTE FUNCTION touch_runs_updated_at();

-- ===== Optional seed data for smoke testing (commented out) =====
-- You don't know real Firebase UIDs until users sign in.
-- Uncomment and change values if you want to test queries right away.
-- INSERT INTO users (firebase_uid, display_name, email)
-- VALUES ('test_uid_1', 'You', 'you@example.com'),
--        ('test_uid_2', 'Friend', 'friend@example.com')
-- ON CONFLICT (firebase_uid) DO NOTHING;