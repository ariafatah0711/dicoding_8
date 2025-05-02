# mengggunakan image Node.js 18 berbasis Alpine (ringan) sebagai base image
FROM node:18-alpine as base
# Set direktori kerja di dalam container ke /src
WORKDIR /src
# Salin file package.json dan package-lock.json ke dalam container
COPY package*.json ./

# ====== PRODUCTION BUILD ======
FROM base as production
# Set environment variable ke production
ENV NODE_ENV=production 
# Install dependencies secara clean untuk productison (tanpa devDependencies)
RUN npm ci
# Salin semua file JavaScript di root ke /src di container
COPY ./*.js ./
CMD ["node", "index.js"]

# ====== DEVELOPMENT BUILD ======
FROM base as dev
# Install bash untuk menjalankan skrip shell dalam development
RUN apk add --no-cache bash
# Unduh skrip "wait-for-it" untuk menunggu service lain (misalnya DB) sebelum mulai
RUN wget -O /bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
# Ubah permission agar skrip dapat dieksekusi
RUN chmod +x /bin/wait-for-it.sh

# Set environment variable ke development
ENV NODE_ENV=development
# Install semua dependencies (termasuk devDependencies)
RUN npm install
# Salin semua file JavaScript di root ke /src di container
COPY ./*.js ./
CMD ["node", "index.js"]