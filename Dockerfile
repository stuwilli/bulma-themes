# Build stage
FROM node:12.22.12-bullseye as build-stage

RUN apt update && apt install python git -y

WORKDIR /app

COPY package*.json ./
RUN yarn install

COPY . .
#RUN npm run generate-client
RUN yarn run build

# Production stage
FROM node:12.22.12-bullseye as production-stage

WORKDIR /app

COPY --from=build-stage /app/dist ./dist
COPY package*.json ./

# Install only production npm dependencies
RUN npm install --only=production

# Server script that serves your dist folder
COPY server.cjs .

# Expose the app on port 8080
EXPOSE 8080

CMD ["node", "server.cjs"]