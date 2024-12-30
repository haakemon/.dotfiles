// const entry = `${App.configDir}/main.ts`;
const outdir = `${App.configDir}/dist`;

async function init() {
  try {
    await import(`file://${outdir}/main.js`);
  } catch (error) {
    App.quit();
    console.error(error);
  }
}

init();
