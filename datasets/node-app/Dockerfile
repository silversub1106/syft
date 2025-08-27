FROM node:18-slim 
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
CMD ["node", "-e", "console.log('ok')"]
