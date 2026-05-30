# Using alpine to keep the image small
FROM node:20-alpine AS builder

WORKDIR /app

# copying package.json first so docker doesnt reinstall packages everytime
COPY package*.json ./
RUN npm ci --frozen-lockfile

COPY . .
RUN npm run build

# remove dev dependencies
RUN npm prune --production

# final image - Prod
FROM node:20-alpine AS production

# dont run as root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

#minimizing the imaeg
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/package*.json ./

USER appuser
# Exposing the APP
EXPOSE 3000

# basic health chec k
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/index.js"]
