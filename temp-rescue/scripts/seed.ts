/**
 * Stub seed runner intended to be replaced with project-specific initial data loading.
 *
 * Replace this function's body with calls to ORMs, HTTP clients, or fixtures to populate development data for local or CI environments.
 */
async function runSeed() {
  console.log(
    "[Kit Fundador] scripts/seed.ts es un stub listo para personalizar."
  );
  console.log(
    "Aquí puedes invocar ORMs, clientes HTTP o fixtures para poblar tu entorno."
  );
}

// ESM-compatible main-guard pattern
if (import.meta.url === `file://${process.argv[1]}`) {
  runSeed().catch(error => {
    console.error("Seed de ejemplo falló:", error);
    process.exit(1);
  });
}

export { runSeed };