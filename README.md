# Discord Bot Multi Player

## Features

### Highlights

- Simple & easy to use 😁
- Support YouTube, SoundCloud and [other...](https://ytdl-org.github.io/youtube-dl/supportedsites.html) 👌
- Play in several channels at the same time on the same server 🎵
- Slash Commands support 🤖
- Embed view to control the player with buttons 🎛️

![screen](./docs/screenshot.png)

### Commands

| Name          |                         Description                         | Options |
|:--------------|:-----------------------------------------------------------:|--------:|
| **/play**     |               Play from url or resume player                |  \<url> |
| **/pause**    |                   Pause the current song                    |         |
| **/next**     |                      Go to next track                       |         |
| **/previous** |                   Play the previous track                   |         |
| **/stop**     |                       Stop the player                       |         |
| **/add**      |             Add track in current playing queue              |     url |
| **/repeat**   | Change repeat mode **[one, all, none]** (default: **none**) |    mode |


## yt-dlp installation

To install yt-dlp according to your CPU architecture (x86_64/aarch64/armv7l):

- Latest release:
  ./scripts/install_yt_dlp.sh

- Specific version:
  YT_DLP_VERSION=2025.01.01 ./scripts/install_yt_dlp.sh

- Custom destination directory:
  ./scripts/install_yt_dlp.sh /path/to/bin

Notes:
- The script tries to install to /usr/local/bin if writable; otherwise it falls back to ./bin.
- If installed to ./bin, add it to PATH, e.g.: export PATH="$(pwd)/bin:$PATH"

## Development (Docker)
- In dev mode, the app runs inside a Docker container.
- Start detached: `make up`
- Open a shell in the dev container: `make shell`
- Run a one-shot command: `make shell npm test`
- Live/hot dev alternative (foreground): `make dev` (use another terminal and run `make shell` for commands)
