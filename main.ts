// Assemble the authored Roblox place, source tree, and capture folder for make.fun review.
import { copyFileSync, cpSync, existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { basename, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const root = fileURLToPath(new URL('.', import.meta.url));
const output = process.env.MAKEFUN_OUTPUT_DIR || '/output';
const includePublicEntries = (path: string) => !basename(path).startsWith('.');
const copyIfPresent = (source: string, destination: string) => {
  if (existsSync(source)) cpSync(source, destination, { recursive: true, filter: includePublicEntries });
};

mkdirSync(output, { recursive: true });
copyIfPresent(join(root, 'src'), join(output, 'src'));
for (const artifact of ['PLAY.json', 'game.rbxl']) copyFileSync(join(root, artifact), join(output, artifact));
mkdirSync(join(output, 'screenshots'), { recursive: true });
copyIfPresent(join(root, 'screenshots'), join(output, 'screenshots'));

const dossier = buildDossier(output, {
  text_max_bytes: 65536,
  screenshots: { max: 4, max_bytes: 262144 },
  max_instances: 500000,
  scripts_max_source_bytes: 8388608,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(output, 'dossier.json'), dossier);
