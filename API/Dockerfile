FROM node:18

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install
RUN npm rebuild sqlite3 --build-from-source

# Copy source code
COPY . .

# Expose port 3000
EXPOSE 3000

CMD ["node", "server.js"]
