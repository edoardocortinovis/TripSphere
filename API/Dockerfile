FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache python3 build-base

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install
RUN npm rebuild sqlite3 --build-from-source

# Copy rest of the application
COPY . .

# Expose port 3000 (based on the README mentions of localhost:3000)
EXPOSE 3000

# Start the server
CMD ["node", "server.js"]