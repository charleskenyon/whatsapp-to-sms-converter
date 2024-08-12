# Puppeteer base image setup
FROM node:20-alpine AS base

RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      freetype-dev \
      harfbuzz \
      ca-certificates \
      ttf-freefont

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser

# Build stage
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm i

COPY src ./src

COPY tsconfig.json ./tsconfig.json

RUN npm run build

# Production stage
FROM base

COPY package*.json ./

RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

CMD ["node", "dist/run.js"]

# docker build . --tag=whatsapp , docker run whatsapp
 