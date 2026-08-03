/**
 * Screenshot each bottom-nav tab of the manabi_do web build.
 * Usage: NODE_PATH=scripts/pw/node_modules node scripts/screenshot_tab.js [port] [outputDir]
 *
 * Note: the grammar tab requires the app to be built with _grammarEnabled = true,
 * otherwise it renders the lock overlay.
 */
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const PORT = process.argv[2] || '8767';
const OUTDIR = process.argv[3] || `${__dirname}/output`;
const URL = `http://localhost:${PORT}`;
const FONT = process.env.SCREENSHOT_FONT || '/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf';
const CHROMIUM_PATH = process.env.CHROMIUM_PATH || undefined;

// Bottom nav tab coords (390×844 viewport). y=797 confirmed working across scripts.
const TABS = [
  { name: 'home',       x:  45, y: 797 },
  { name: 'characters', x: 120, y: 797 },
  { name: 'vocabulary', x: 195, y: 797 },
  { name: 'grammar',    x: 270, y: 797 },
  { name: 'settings',   x: 344, y: 797 },
];

(async () => {
  fs.mkdirSync(OUTDIR, { recursive: true });
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
  await page.route('https://fonts.gstatic.com/**', route =>
    route.fulfill({ status: 200, contentType: 'font/ttf', body: font }));
  page.on('pageerror', err => console.error('PAGE ERROR:', err));
  page.on('console', msg => { if (msg.type() === 'error') console.error('CONSOLE ERROR:', msg.text()); });

  await page.goto(URL, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(5000);

  for (const tab of TABS) {
    await page.mouse.click(tab.x, tab.y);
    await page.waitForTimeout(1500);
    const out = path.join(OUTDIR, `${tab.name}.png`);
    await page.screenshot({ path: out });
    console.log(`saved ${out}`);
  }

  await browser.close();
})();
