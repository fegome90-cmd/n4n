/**
 * Stub seed runner intended to be replaced with actual initial data population logic.
 *
 * Replace this placeholder with calls to ORMs, HTTP clients, fixtures, or other routines that
 * populate the application's initial data environment. Currently it only logs informational messages.
 */
async function runSeed() {
  console.log(
    "[Kit Fundador] scripts/seed.ts es un stub listo para personalizar."
  );
  console.log(
    "Aquí puedes invocar ORMs, clientes HTTP o fixtures para poblar tu entorno."
  );
}

if (require.main === module) {
  runSeed().catch(error => {
    console.error("Seed de ejemplo falló:", error);
    process.exit(1);
  });
}

export { runSeed };