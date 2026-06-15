/**
 * Icon & OG image generator
 * Run: npm install sharp  →  node generate-icons.js
 */
const sharp  = require('sharp');
const path   = require('path');
const ROOT   = __dirname;

/* ─── SVG templates ─────────────────────────────────────── */

function iconSvg(size) {
  const rx   = Math.round(size * 0.225);
  const fs   = Math.round(size * 0.415);
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}" width="${size}" height="${size}">
  <rect width="${size}" height="${size}" rx="${rx}" fill="#1f8a70"/>
  <text x="50%" y="52%"
    font-family="Arial, Helvetica, sans-serif"
    font-size="${fs}" font-weight="700"
    fill="#ffffff" text-anchor="middle"
    dominant-baseline="central">DH</text>
</svg>`;
}

const ogSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <radialGradient id="bg" cx="40%" cy="50%" r="75%">
      <stop offset="0%" stop-color="#1e3a6e"/>
      <stop offset="100%" stop-color="#0a0f1e"/>
    </radialGradient>
  </defs>
  <rect width="1200" height="630" fill="url(#bg)"/>

  <!-- DH icon -->
  <rect x="524" y="110" width="152" height="152" rx="34" fill="#1f8a70"/>
  <text x="600" y="193"
    font-family="Arial, Helvetica, sans-serif" font-size="64" font-weight="700"
    fill="#ffffff" text-anchor="middle" dominant-baseline="central">DH</text>

  <!-- Name -->
  <text x="600" y="325"
    font-family="Arial, Helvetica, sans-serif" font-size="54" font-weight="700"
    fill="#ffffff" text-anchor="middle" letter-spacing="-1">Daniel Havlicek</text>

  <!-- Subtitle -->
  <text x="600" y="396"
    font-family="Arial, Helvetica, sans-serif" font-size="26"
    fill="rgba(255,255,255,0.6)" text-anchor="middle">Tvorba webu Praha od 3 000 Kc</text>

  <!-- Divider -->
  <rect x="540" y="446" width="120" height="2" rx="1" fill="rgba(31,138,112,0.6)"/>

  <!-- URL -->
  <text x="600" y="496"
    font-family="Arial, Helvetica, sans-serif" font-size="20"
    fill="rgba(255,255,255,0.35)" text-anchor="middle" letter-spacing="1">danielhavlicek.cz</text>
</svg>`;

/* ─── Generate ───────────────────────────────────────────── */

async function run() {
  const icons = [
    { file: 'favicon-16x16.png',    size: 16  },
    { file: 'favicon-32x32.png',    size: 32  },
    { file: 'apple-touch-icon.png', size: 180 },
  ];

  for (const { file, size } of icons) {
    await sharp(Buffer.from(iconSvg(size)))
      .png()
      .toFile(path.join(ROOT, file));
    console.log(`✓  ${file}`);
  }

  await sharp(Buffer.from(ogSvg))
    .png()
    .toFile(path.join(ROOT, 'og-image.png'));
  console.log('✓  og-image.png (1200×630)');

  console.log('\nDone. All 4 files written to project root.');
}

run().catch(err => {
  console.error('Error:', err.message);
  if (err.message.includes("Cannot find module 'sharp'")) {
    console.error('\nRun: npm install sharp   …then try again.');
  }
});
