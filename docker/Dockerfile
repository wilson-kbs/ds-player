FROM node:20-bullseye AS builder
RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential autoconf automake python3 make ffmpeg libtool ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./package.json ./
# Yarn lock removed; npm will use package-lock.json if present
# COPY ./yarn.lock ./

ENV YOUTUBE_DL_SKIP_DOWNLOAD=true
# Prefer npm ci if package-lock.json exists; fallback to npm install
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
COPY . .
RUN npm run build

#RUN rm -rf ./node_modules
#RUN npm ci --omit=dev

# Removed youtube-dl download; yt-dlp will be installed in the final stage



FROM node:20-bullseye

RUN apt-get update \
  && apt-get install -y --no-install-recommends ffmpeg python3 ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app


COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp

RUN chmod a+rx /usr/local/bin/yt-dlp

VOLUME /data

EXPOSE 3000

CMD ["npm", "run", "start:prod"]
