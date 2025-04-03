FROM node:18-alpine
WORKDIR /app
RUN apk add --no-cache python3 gyp build-base
COPY package*.json ./
RUN npm install
RUN npm install python3
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]