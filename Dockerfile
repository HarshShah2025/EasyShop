## Stage1

## Base image for builder
FROM node:18-alpine AS builder

## Create a working directory
WORKDIR /project

## install the required dependencies 
COPY package*.json ./
RUN npm install --include=dev


## Copy source code
COPY . .

## Build node.js app
RUN npm run build

## Production Stage

## Base image
FROM node:18-alpine AS runner

## Create working directory
WORKDIR /project

## Copy the requirements from builder
COPY --from=builder /project ./


## set the environment variable

ENV NODE_ENV=production

## Expose the port
EXPOSE 3000

## Serve the app
CMD ["npm", "start"]

