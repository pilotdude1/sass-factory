import sharp from 'sharp';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const screenshots = [
	{
		name: 'desktop-1',
		width: 1280,
		height: 800
	},
	{
		name: 'desktop-2',
		width: 1920,
		height: 1080
	},
	{
		name: 'mobile-1',
		width: 750,
		height: 1334
	},
	{
		name: 'mobile-2',
		width: 1080,
		height: 1920
	}
];

async function generateScreenshots() {
	for (const screenshot of screenshots) {
		// Create a placeholder image with the app name and dimensions
		const svgBuffer = Buffer.from(`
      <svg width="${screenshot.width}" height="${screenshot.height}" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="#4A90E2"/>
        <text x="50%" y="50%" font-family="Arial" font-size="48" fill="white" text-anchor="middle" dominant-baseline="middle">
          Sass Factory PWA
        </text>
        <text x="50%" y="60%" font-family="Arial" font-size="24" fill="white" text-anchor="middle" dominant-baseline="middle">
          ${screenshot.width}x${screenshot.height} Screenshot
        </text>
      </svg>
    `);

		await sharp(svgBuffer)
			.png()
			.toFile(join(__dirname, `../static/screenshots/${screenshot.name}.png`));

		console.log(`Generated ${screenshot.name}.png (${screenshot.width}x${screenshot.height})`);
	}
}

generateScreenshots().catch(console.error);
