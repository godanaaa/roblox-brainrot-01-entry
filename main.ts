// Package the finished Rojo place and its authored Lua sources for the make.fun entry.
// Output goes to MAKEFUN_OUTPUT_DIR during local checks and /output in the scorer.
import { copyFileSync, cpSync, existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { basename, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const projectRoot = fileURLToPath(new URL('.', import.meta.url));
const destination = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
mkdirSync(destination, { recursive: true });
const includeVisibleNames = (sourcePath: string): boolean => !basename(sourcePath).startsWith('.');

copyFileSync(join(projectRoot, 'game.rbxl'), join(destination, 'game.rbxl'));
copyFileSync(join(projectRoot, 'PLAY.json'), join(destination, 'PLAY.json'));
cpSync(join(projectRoot, 'src'), join(destination, 'src'), { recursive: true, filter: includeVisibleNames });
mkdirSync(join(destination, 'screenshots'), { recursive: true });
const captures = join(projectRoot, 'screenshots');
if (existsSync(captures)) cpSync(captures, join(destination, 'screenshots'), { recursive: true, filter: includeVisibleNames });

writeFileSync(
  join(destination, 'dossier.json'),
  buildDossier(destination, {
    text_max_bytes: 65536,
    screenshots: { max: 4, max_bytes: 262144 },
    max_instances: 500000,
    scripts_max_source_bytes: 8388608,
    scripts_max_path_chars: 1048576,
  }),
);
