[![make.fun · roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![rank](https://make.fun/badge/roblox-brainrot-01/godanaaa/roblox-brainrot-01-entry/rank.svg)](https://make.fun/bounty/roblox-brainrot-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
[![reward](https://make.fun/badge/roblox-brainrot-01/godanaaa/roblox-brainrot-01-entry/reward.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)

# BRAINROT MAYHEM

A 3D Roblox brainrot game built for [make.fun's "Make the best AI Roblox brainrot game" bounty](https://make.fun/bounty/roblox-brainrot-01) ($1,000 in USDC).

Catch weirdos. Build your base. Survive the chaos. A normal neighbourhood where a ridiculous chaos event fires every 20-60 seconds - Banana Rain, Giant Player, Tiny People, and the ultra-rare BRAINROT event. Catch 12 original brainrots, place them on your base plots, earn Meme Coins every second, climb the rarity ladder, and unlock pets, transformations, mini-games, secrets, and daily challenges.

- Play it: https://www.roblox.com/games/110997764384288
- `main.ts` (Node 22, standard library only) hands the game in: it copies `game.rbxl`, `src/`, `screenshots/` and `PLAY.json` to `/output` and writes `/output/dossier.json` with `vendor/makefun-roblox.ts`, the kit's copy, unchanged.
- `game.rbxl` is the place Rojo builds from `src/` and `default.project.json`; `screenshots/` holds four captures of it; `PLAY.json` names the published place.
- One of the screenshots is also the game's first thumbnail on Roblox: the same picture, uploaded on the Creator Dashboard with the game's icon.

Run it as the grader does, writing `out/` in place of `/output`:

    mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

Build the place with Rojo:

    rojo build default.project.json -o game.rbxl

Referral: https://make.fun/r/3wc56acn
