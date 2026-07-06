/**
 * Screenshots the full basics grammar flow:
 *   - Grammar level selector
 *   - Basics chapter list
 *   - Each chapter (lesson list if multi-lesson, or lesson directly)
 *   - Each individual lesson
 *
 * Usage:
 *   NODE_PATH=/tmp/pw-test/node_modules node scripts/screenshot_grammar.js [port]
 *
 * Requires the app to be built with _grammarEnabled = true and served on the given port.
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const PORT = process.argv[2] || '8767';
const FONT = '/usr/share/fonts/truetype/dejavu/DejaVuSans-BoldOblique.ttf';
const OUT_DIR = path.join(__dirname, '../screenshots/grammar');

const BACK = async (page) => {
  await page.mouse.click(28, 32);
  await page.waitForTimeout(1000);
};

const shot = async (page, name) => {
  const file = path.join(OUT_DIR, `${name}.png`);
  await page.screenshot({ path: file });
  console.log(`saved ${name}.png`);
};

// Chapter y-coords on the basics chapter list screen (5 chapters, ~57px apart)
const CHAPTER_Y = [202, 259, 316, 373, 430];

// Chapters with multiple lessons and their lesson y-coords on the lesson list screen
// Lesson list items start at ~88px (after AppBar), ~72px apart
const MULTI_LESSON_CHAPTERS = {
  1: { name: 'sentence_structure', lessonCount: 4 },
  3: { name: 'small_kana',         lessonCount: 3 },
};

(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  const font = fs.readFileSync(FONT);

  const browser = await chromium.launch({
    args: ['--no-sandbox', '--use-gl=swiftshader', '--disable-gpu-sandbox', '--enable-webgl', '--ignore-gpu-blocklist'],
  });
  const page = await browser.newPage({ viewport: { width: 390, height: 844 }, colorScheme: 'dark' });
  await page.route('https://fonts.gstatic.com/**', route =>
    route.fulfill({ status: 200, contentType: 'font/ttf', body: font }));
  page.on('pageerror', err => console.error('PAGE ERROR:', err));
  page.on('console', msg => { if (msg.type() === 'error') console.error('CONSOLE:', msg.text()); });

  await page.goto(`http://localhost:${PORT}`, { waitUntil: 'load', timeout: 30000 });
  await page.waitForTimeout(5000);

  // Grammar level selector
  await page.mouse.click(270, 797); // Grammar tab
  await page.waitForTimeout(2000);
  await shot(page, '01_grammar_levels');

  // Basics chapter list
  await page.mouse.click(195, 148); // Japanese Basics card
  await page.waitForTimeout(2000);
  await shot(page, '02_basics_chapters');

  // Each chapter
  for (let i = 0; i < CHAPTER_Y.length; i++) {
    await page.mouse.click(195, CHAPTER_Y[i]);
    await page.waitForTimeout(2000);

    if (MULTI_LESSON_CHAPTERS[i]) {
      const { name, lessonCount } = MULTI_LESSON_CHAPTERS[i];
      await shot(page, `03_${name}_lessons`);

      // Click each lesson (items start at y≈88, ~72px apart)
      for (let j = 0; j < lessonCount; j++) {
        const lessonY = 88 + j * 72;
        await page.mouse.click(195, lessonY);
        await page.waitForTimeout(2000);
        await shot(page, `03_${name}_lesson_${j + 1}`);
        await BACK(page);
        await page.waitForTimeout(1000);
      }

      await BACK(page); // back to chapter list
    } else {
      const chapterNames = ['how_japanese_is_written', null, 'punctuation', null, 'pitch_accent'];
      await shot(page, `03_${chapterNames[i]}`);
      await BACK(page); // back to chapter list
    }

    await page.waitForTimeout(1000);
  }

  await browser.close();
  console.log(`\nAll screenshots saved to screenshots/grammar/`);
})();
