/**
 * Screenshots a representative sample of N5 grammar screens:
 *   - N5 chapter list (top + scrolled)
 *   - A selection of lessons covering every block type
 *
 * Usage:
 *   NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot_grammar_n5.js [port]
 *
 * Requires the app to be built with _grammarEnabled = true and served on the given port.
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const PORT = process.argv[2] || '8767';
const FONT = process.env.SCREENSHOT_FONT || '/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf';
const CHROMIUM_PATH = process.env.CHROMIUM_PATH || undefined;
const OUT_DIR = path.join(__dirname, '../screenshots/n5');

const BACK = async (page) => {
  await page.mouse.click(28, 32);
  await page.waitForTimeout(1000);
};

const shot = async (page, name) => {
  const file = path.join(OUT_DIR, `${name}.png`);
  await page.screenshot({ path: file });
  console.log(`saved ${name}.png`);
};

const scroll = async (page, dy) => {
  await page.mouse.wheel(0, dy);
  await page.waitForTimeout(800);
};

// N5 chapter y-coords on the chapter list screen (73px spacing, first at ~210).
const CHAPTER_Y = [210, 283, 356, 429, 502, 575, 648, 721];

// Lesson y-coord by index (first at ~96, spacing ~88px).
const lessonY = (i) => 96 + i * 88;

(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  const font = fs.readFileSync(FONT);

  const browser = await chromium.launch({
    ...(CHROMIUM_PATH ? { executablePath: CHROMIUM_PATH } : {}),
    args: ['--no-sandbox', '--use-gl=swiftshader', '--disable-gpu-sandbox', '--enable-webgl', '--ignore-gpu-blocklist'],
  });
  const page = await browser.newPage({ viewport: { width: 390, height: 844 }, colorScheme: 'dark' });
  await page.route('https://fonts.gstatic.com/**', route =>
    route.fulfill({ status: 200, contentType: 'font/ttf', body: font }));
  page.on('pageerror', err => console.error('PAGE ERROR:', err));
  page.on('console', msg => { if (msg.type() === 'error') console.error('CONSOLE:', msg.text()); });

  await page.goto(`http://localhost:${PORT}`, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(5000);

  // ── Grammar tab → N5 ──────────────────────────────────────────────────────
  await page.mouse.click(270, 797); // Grammar tab
  await page.waitForTimeout(2000);

  await page.mouse.click(195, 260); // N5 card
  await page.waitForTimeout(2000);
  await shot(page, '01_chapters_top');

  await scroll(page, 400);
  await shot(page, '02_chapters_bottom');
  await scroll(page, -400); // reset scroll

  // ── Ch.1 Verbs — lesson 1: Verb Groups (vocab_table) ─────────────────────
  await page.mouse.click(195, CHAPTER_Y[0]);
  await page.waitForTimeout(2000);
  await shot(page, '03_ch1_verbs_lessons');

  await page.mouse.click(195, lessonY(0));
  await page.waitForTimeout(2000);
  await shot(page, '04_verb_groups');
  await BACK(page);

  // lesson 2: ます (pattern + conjugation pattern)
  await page.mouse.click(195, lessonY(1));
  await page.waitForTimeout(2000);
  await shot(page, '05_masu_form');
  await BACK(page);
  await BACK(page); // back to chapter list

  // ── Ch.2 Particles — lesson 2: で (comparison block) ─────────────────────
  await page.waitForTimeout(500);
  await page.mouse.click(195, CHAPTER_Y[1]);
  await page.waitForTimeout(2000);
  await shot(page, '06_ch2_particles_lessons');

  await page.mouse.click(195, lessonY(1)); // で
  await page.waitForTimeout(2000);
  await shot(page, '07_de_location');
  await BACK(page);

  await page.mouse.click(195, lessonY(2)); // いる/ある
  await page.waitForTimeout(2000);
  await shot(page, '08_iru_aru');
  await BACK(page);
  await BACK(page);

  // ── Ch.5 Adjectives — lesson 2: な-adj (comparison + conjugation table) ──
  await page.waitForTimeout(500);
  await page.mouse.click(195, CHAPTER_Y[4]);
  await page.waitForTimeout(2000);

  await page.mouse.click(195, lessonY(0)); // い-adj
  await page.waitForTimeout(2000);
  await shot(page, '09_i_adjectives');
  await BACK(page);

  await page.mouse.click(195, lessonY(1)); // な-adj
  await page.waitForTimeout(2000);
  await shot(page, '10_na_adjectives');
  await BACK(page);
  await BACK(page);

  // ── Ch.9 て-form — lesson 1: forming (pattern + vocab_table) ─────────────
  await page.waitForTimeout(500);
  // ch9 is off-screen, scroll to it
  await scroll(page, 300);
  await page.waitForTimeout(500);
  await page.mouse.click(195, CHAPTER_Y[4]); // ch9 after scrolling ~4 chapters up
  await page.waitForTimeout(2000);

  await page.mouse.click(195, lessonY(0));
  await page.waitForTimeout(2000);
  await shot(page, '11_te_form_formation');
  await BACK(page);

  await page.mouse.click(195, lessonY(3)); // giving/receiving (list block)
  await page.waitForTimeout(2000);
  await shot(page, '12_giving_receiving');
  await BACK(page);
  await BACK(page);
  await scroll(page, -300);

  // ── Ch.12 Obligation — lesson 2: must/don't have to (comparison) ─────────
  await page.waitForTimeout(500);
  await scroll(page, 600);
  await page.waitForTimeout(500);
  await page.mouse.click(195, CHAPTER_Y[3]); // ch12 after scrolling
  await page.waitForTimeout(2000);
  await shot(page, '13_ch12_obligation_lessons');

  await page.mouse.click(195, lessonY(1)); // must & don't have to
  await page.waitForTimeout(2000);
  await shot(page, '14_must_dont_have_to');
  await BACK(page);

  await page.mouse.click(195, lessonY(4)); // んです
  await page.waitForTimeout(2000);
  await shot(page, '15_n_desu');
  await BACK(page);

  await page.mouse.click(195, lessonY(5)); // 中
  await page.waitForTimeout(2000);
  await shot(page, '16_naka');
  await BACK(page);
  await BACK(page);

  await browser.close();
  console.log(`\nAll N5 screenshots saved to screenshots/n5/`);
})();
