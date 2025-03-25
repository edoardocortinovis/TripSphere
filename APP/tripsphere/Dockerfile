FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application
COPY . .

# Build the application
RUN npm run build

# Expose port 8080 (default Vue development server port)
EXPOSE 8080

# Start the development server
CMD ["npm", "run", "serve"]