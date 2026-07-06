/**
 * Headless screenshot tool for manabi_do web build.
 *
 * Usage:
 *   node scripts/screenshot.js [port] [output]
 *
 * Defaults: port=8767, output=screenshots/screenshot.png (repo root)
 *
 * Before running:
 *   1. Build: cd manabi_do && flutter build web -t lib/main.dart --no-web-resources-cdn --debug
 *   2. Serve: setsid nohup python3 -m http.server 8768 --bind 0.0.0.0 \
 *               --directory manabi_do/build/web > /tmp/webserver.log 2>&1 < /dev/null & disown
 *
 * Playwright must be installed:
 *   npm install playwright  (in /tmp/pw-test or any scratch dir)
 *   npx playwright install chromium
 * Then run from the repo root: node --require /tmp/pw-test/node_modules/playwright scripts/screenshot.js
 * Or set NODE_PATH=/tmp/pw-test/node_modules and run directly.
 */

const { chromium } = require('playwright');
const fs = require('fs');

const PORT = process.argv[2] || '8767';
const OUTPUT = process.argv[3] || `${__dirname}/../screenshots/screenshot.png`;
const URL = `http://localhost:${PORT}`;
const FONT = '/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf';

(async () => {
  fs.mkdirSync(require('path').dirname(OUTPUT), { recursive: true });
  const font = fs.readFileSync(FONT);
  const browser = await chromium.launch({
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
