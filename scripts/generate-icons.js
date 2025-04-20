import sharp from 'sharp';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const sizes = [192, 512];
const inputFile = join(__dirname, '../static/icons/icon.svg');

async function generateIcons() {
	for (const size of sizes) {
		await sharp(inputFile)
			.resize(size, size)
			.png()
			.toFile(join(__dirname, `../static/icons/icon-${size}x${size}.png`));
		console.log(`Generated ${size}x${size} icon`);
	}
}

generateIcons().catch(console.error);
