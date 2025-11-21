/* eslint-disable no-console */
import fs from "fs";
import path from "path";
import { Client } from "pg";
import { config as loadEnvConfig } from "dotenv";

type Action = "up" | "down" | "create";

type MigrationParts = {
  up: string;
  down: string | null;
};

const MIGRATIONS_DIR = path.resolve(process.cwd(), "db/migrations");
const HISTORY_TABLE = "kit_migrations";

const ENV_PATH = path.resolve(process.cwd(), ".env");
loadEnvConfig({ path: ENV_PATH });

const DEFAULT_DB_USER = process.env.DB_USER ?? "dev";
const DEFAULT_DB_PASSWORD = process.env.DB_PASSWORD ?? "devpass";
const DEFAULT_DB_NAME = process.env.DB_NAME ?? "myapp_dev";

const FALLBACK_URL = `postgresql://${DEFAULT_DB_USER}:${DEFAULT_DB_PASSWORD}@localhost:5432/${DEFAULT_DB_NAME}`;

/**
 * Resolve the PostgreSQL connection URL, preferring the environment variable.
 *
 * @returns The database connection URL: `process.env.DATABASE_URL` when set and non-empty, otherwise the fallback connection string (`FALLBACK_URL`).
 */
function resolveDatabaseUrl(): string {
  const fromEnv = process.env.DATABASE_URL?.trim();
  return fromEnv && fromEnv.length > 0 ? fromEnv : FALLBACK_URL;
}

/**
 * Ensure the migrations directory exists by creating `MIGRATIONS_DIR` and any missing parent directories.
 */
function ensureMigrationsDir(): void {
  if (!fs.existsSync(MIGRATIONS_DIR)) {
    fs.mkdirSync(MIGRATIONS_DIR, { recursive: true });
  }
}

/**
 * List available migration SQL filenames in the migrations directory.
 *
 * Ensures the migrations directory exists, then returns all files whose names end with `.sql`.
 *
 * @returns An array of migration filenames (strings ending with `.sql`) sorted alphabetically.
 */
function listMigrationFiles(): string[] {
  ensureMigrationsDir();
  return fs
    .readdirSync(MIGRATIONS_DIR)
    .filter(file => file.endsWith(".sql"))
    .sort();
}

/**
 * Extracts the `up` and `down` SQL sections from a migration file.
 *
 * The function recognizes `-- up` and `-- down` section headers (case-insensitive) and returns
 * the SQL before the `-- down` header as the `up` section and the SQL after as the `down` section.
 *
 * @param filePath - Path to the `.sql` migration file to read
 * @returns `MigrationParts` where `up` is the SQL for applying the migration (empty string if absent)
 *          and `down` is the SQL for reverting the migration or `null` if no `-- down` section exists
 */
function readMigrationParts(filePath: string): MigrationParts {
  const raw = fs.readFileSync(filePath, "utf8");
  const parts = raw.split(/^--\s*down\s*$/im);
  const up = parts[0]?.replace(/^--\s*up\s*$/i, "").trim() ?? "";
  const down = parts[1] ? parts[1].trim() : null;

  return { up, down };
}

/**
 * Ensures the migrations history table exists in the database.
 *
 * Creates the kit_migrations table (if missing) that records applied migration filenames and when they were run.
 *
 * Table schema:
 * - `id`: serial primary key
 * - `name`: unique text identifier for the migration file
 * - `run_on`: timestamp with time zone, defaults to now()
 */
async function ensureHistoryTable(client: Client): Promise<void> {
  await client.query(`
    CREATE TABLE IF NOT EXISTS ${HISTORY_TABLE} (
      id SERIAL PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      run_on TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);
}

/**
 * Run migrations against the configured PostgreSQL database in the given direction.
 *
 * Ensures the migration history table exists, applies pending migrations when `direction` is "up",
 * or reverts the most recent applied migration when `direction` is "down"; the database connection
 * is opened for the operation and always closed afterward.
 *
 * @param direction - "up" to apply pending migrations, "down" to revert the latest applied migration
 */
async function runMigrations(
  direction: Extract<Action, "up" | "down">
): Promise<void> {
  const connectionString = resolveDatabaseUrl();
  const client = new Client({ connectionString });

  await client.connect();
  try {
    await ensureHistoryTable(client);

    if (direction === "up") {
      await migrateUp(client);
    } else {
      await migrateDown(client);
    }
  } finally {
    await client.end();
  }
}

/**
 * Applies all pending migrations by executing each file's `-- up` SQL and recording its name in the migrations history table.
 *
 * Skips files already recorded in the history table and skips files that do not contain an `-- up` section. Logs progress to the console.
 */
async function migrateUp(client: Client): Promise<void> {
  const files = listMigrationFiles();
  const applied = await client.query<{ name: string }>(
    `SELECT name FROM ${HISTORY_TABLE} ORDER BY run_on ASC`
  );
  const appliedNames = new Set(applied.rows.map(row => row.name));

  for (const file of files) {
    if (appliedNames.has(file)) {
      continue;
    }

    const filePath = path.join(MIGRATIONS_DIR, file);
    const { up } = readMigrationParts(filePath);
    if (!up) {
      console.log(`[migrate] ${file} no contiene bloque -- up. Se omite.`);
      continue;
    }

    console.log(`[migrate] Ejecutando ${file}`);
    await client.query(up);
    await client.query(`INSERT INTO ${HISTORY_TABLE} (name) VALUES ($1)`, [
      file,
    ]);
  }

  console.log("[migrate] Migraciones al día.");
}

/**
 * Reverts the most recently applied migration.
 *
 * Executes the migration's `-- down` SQL block and removes its record from the migrations history table.
 *
 * @throws Error if the migration file for the latest applied migration does not exist.
 * @throws Error if the migration file does not define a `-- down` block.
 */
async function migrateDown(client: Client): Promise<void> {
  const latest = await client.query<{ name: string }>(
    `SELECT name FROM ${HISTORY_TABLE} ORDER BY run_on DESC LIMIT 1`
  );
  if (latest.rowCount === 0) {
    console.log("[migrate] No hay migraciones para revertir.");
    return;
  }

  const file = latest.rows[0].name as string;
  const filePath = path.join(MIGRATIONS_DIR, file);
  if (!fs.existsSync(filePath)) {
    throw new Error(`No se encontró el archivo ${file} para revertir.`);
  }

  const { down } = readMigrationParts(filePath);
  if (!down) {
    throw new Error(`La migración ${file} no define bloque -- down.`);
  }

  console.log(`[migrate] Revirtiendo ${file}`);
  await client.query(down);
  await client.query(`DELETE FROM ${HISTORY_TABLE} WHERE name = $1`, [file]);
}

/**
 * Convert an arbitrary string into a lowercase, underscore-separated slug containing only ASCII letters and digits.
 *
 * @param name - Input string to slugify
 * @returns A slugified string composed of lowercase letters, digits, and underscores with no leading or trailing underscores
 */
function toSlug(name: string): string {
  return name
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

/**
 * Creates a new SQL migration file in the migrations directory with a timestamped filename and a slugified name.
 *
 * Ensures the migrations directory exists, writes a file named `YYYYMMDDHHMMSS__slug.sql`, and populates it with `-- up` and `-- down` sections.
 *
 * @param rawName - Optional human-readable name used to build the slug portion of the filename; defaults to `"new_migration"` when omitted
 */
function createMigrationFile(rawName?: string): void {
  ensureMigrationsDir();
  const slug = toSlug(rawName ?? "new_migration");
  const timestamp = new Date()
    .toISOString()
    .replace(/[-:TZ.]/g, "")
    .slice(0, 12);
  const fileName = `${timestamp}__${slug || "migration"}.sql`;
  const target = path.join(MIGRATIONS_DIR, fileName);

  const template = `-- up\n-- down\n`;
  fs.writeFileSync(target, template, { encoding: "utf8" });
  console.log(`[migrate] Archivo creado: ${target}`);
}

/**
 * Parse CLI arguments and execute the requested migration action (`create`, `up`, or `down`).
 *
 * If the action is `create`, a new migration file is generated and the process exits.
 * For `up` or `down`, the corresponding migration workflow is executed.
 *
 * @throws Error if the provided action is not `create`, `up`, or `down`
 */
async function main(): Promise<void> {
  const rawArgs = process.argv.slice(2).filter(arg => arg !== "--");
  const action = (rawArgs[0] as Action | undefined) ?? "up";

  if (action === "create") {
    createMigrationFile(rawArgs[1]);
    return;
  }

  if (action !== "up" && action !== "down") {
    throw new Error(`Acción no soportada: ${action}`);
  }

  await runMigrations(action);
}

if (require.main === module) {
  main().catch((error: unknown) => {
    console.error("[migrate] Error:", error);
    process.exit(1);
  });
}