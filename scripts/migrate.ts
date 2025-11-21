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
 * Determine the PostgreSQL connection URL from environment or fallback.
 *
 * @returns The value of `DATABASE_URL` if it is set and not empty, otherwise the fallback connection URL `FALLBACK_URL`.
 */
function resolveDatabaseUrl(): string {
  const fromEnv = process.env.DATABASE_URL?.trim();
  return fromEnv && fromEnv.length > 0 ? fromEnv : FALLBACK_URL;
}

/**
 * Ensures the migrations directory exists, creating it (and parent directories) if missing.
 */
function ensureMigrationsDir(): void {
  if (!fs.existsSync(MIGRATIONS_DIR)) {
    fs.mkdirSync(MIGRATIONS_DIR, { recursive: true });
  }
}

/**
 * Get an alphabetically sorted list of `.sql` migration filenames from the migrations directory.
 *
 * @returns An array of `.sql` filenames present in the migrations directory, sorted alphabetically.
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
 * @param filePath - Path to a `.sql` migration file containing `-- up` and an optional `-- down` marker
 * @returns An object with `up` containing the SQL to apply the migration (empty string if none) and `down` containing the SQL to revert the migration or `null` if no down section exists
 */
function readMigrationParts(filePath: string): MigrationParts {
  const raw = fs.readFileSync(filePath, "utf8");
  const parts = raw.split(/^--\s*down\s*$/im);
  const up = parts[0]?.replace(/^--\s*up\s*$/i, "").trim() ?? "";
  const down = parts[1] ? parts[1].trim() : null;

  return { up, down };
}

/**
 * Ensure the migrations history table exists in the connected database.
 *
 * Creates the history table (kit_migrations) if it does not already exist with the following columns:
 * - `id`: serial primary key
 * - `name`: text, unique, not null
 * - `run_on`: timestamptz, not null, defaults to the current timestamp
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
 * Applies or reverts migrations against the configured PostgreSQL database.
 *
 * Connects to the database, ensures the migration history table exists, executes migrations
 * in the specified direction, and closes the database connection when finished.
 *
 * @param direction - "up" to apply pending migrations; "down" to revert the most recently applied migration
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
 * Applies unapplied migrations by executing each file's `-- up` SQL in order and recording them in the history table.
 *
 * Reads migration files from the migrations directory, skips entries already present in the history table, executes the `up` section for each unapplied migration, inserts the migration name into the history table, and logs progress. Migrations without an `-- up` section are skipped.
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
 * Reverts the most recently applied migration by executing its `-- down` SQL and removing its history entry.
 *
 * Looks up the latest migration recorded in the history table, validates the corresponding migration file exists
 * and contains a `-- down` section, runs that SQL against the database, and deletes the migration row from the history table.
 *
 * @throws If the migration file referenced in history does not exist.
 * @throws If the migration file does not define a `-- down` block.
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
 * Produces a filesystem-friendly lowercase slug from a migration name.
 *
 * @param name - The input name to convert into a slug (e.g., migration title or filename fragment)
 * @returns The normalized slug: lowercase, non-alphanumeric sequences replaced with single underscores, with no leading or trailing underscores
 */
function toSlug(name: string): string {
  return name
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

/**
 * Creates a new SQL migration file in the migrations directory with an up/down template.
 *
 * The file is named using a timestamp prefix and a slugified version of `rawName` in the
 * form `<timestamp>__<slug>.sql` and is written to the configured migrations directory.
 *
 * @param rawName - Optional human-readable name used to generate the file slug; defaults to `"new_migration"`
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
 * Parse command-line arguments and execute the requested migration action.
 *
 * Supports "create" (creates a new migration file), "up" (apply pending migrations), and "down" (revert the latest migration). Defaults to "up" when no action is provided.
 *
 * @throws Error when an unsupported action is supplied (message: `Acción no soportada: <action>`).
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