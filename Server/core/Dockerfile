# Stage 1: Build
FROM node:22 AS builder
WORKDIR /app

COPY package*.json ./

CMD ["apk add","--no-cache","bind-tools"]
CMD ["nslookup" , "visiongate.postgres.database.azure.com"]

RUN npm install

COPY . .
RUN npm run build

# Stage 2: Run
FROM node:22-alpine
WORKDIR /app

# Copy only needed files
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# If you need env files
COPY .local.env .local.env

EXPOSE 3000
CMD ["node", "dist/main.js"]

