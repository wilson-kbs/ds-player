rm -rf ./dist
if [ -f package-lock.json ]; then npm ci; else npm install; fi
npm run start:dev
