/**
 * Headless screenshot tool for manabi_do web build.
 *
 * Usage:
 *   NODE_PATH=scripts/screenshot/pw/node_modules node scripts/screenshot/screenshot.js [port] [output]
 *
 * Defaults: port=8767, output=scripts/screenshot/output/screenshot.png
 *
 * Before running:
 *   1. Build: bash scripts/run/run-web.sh [port]
 *   2. Playwright: run scripts/screenshot/rebuild_and_screenshot.sh once to auto-install
 */

const { chromium } = require('playwright');
const fs = require('fs');

const PORT = process.argv[2] || '8767';
const OUTPUT = process.argv[3] || `${__dirname}/output/screenshot.png`;
const URL = `http://localhost:${PORT}`;
const FONT = process.env.SCREENSHOT_FONT || '/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf';
const CHROMIUM_PATH = process.env.CHROMIUM_PATH || undefined;

(async () => {
  fs.mkdirSync(require('path').dirname(OUTPUT), { recursive: true });
  const font = fs.readFileSync(FONT);
  const browser = await chromium.launch({
    ...(CHROMIUM_PATH ? { executablePath: CHROMIUM_PATH } : {}),
    args: [
      '--no-sandbox',
      '--use-gl=swiftshader',
      '--disable-gpu-sandbox',
      '--enable-webgl',
      '--ignore-gpu-blocklist',
    ],
  });

  const page = await browser.newPage({ viewport: { width: 390, height: 844 }, colorScheme: 'dark' });

  // Intercept gstatic font requests — may be blocked or slow
  await page.route('https://fonts.gstatic.com/**', route =>
    route.fulfill({ status: 200, contentType: 'font/ttf', body: font }));

  page.on('pageerror', err => console.error('PAGE ERROR:', err));
  page.on('console', msg => { if (msg.type() === 'error') console.error('CONSOLE ERROR:', msg.text()); });

  await page.goto(URL, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(5000); // wait for Flutter canvas to fully render

  await page.screenshot({ path: OUTPUT });
  console.log(`screenshot saved to ${OUTPUT}`);

  await browser.close();
})();
