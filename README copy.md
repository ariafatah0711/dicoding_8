# a433-microservices
Repository ini digunakan untuk kebutuhan kelas Belajar Membangun Arsitektur Microservices

Silakan clone dengan perintah berikut.<br>
`git clone -b proyek-pertama https://github.com/dicodingacademy/a433-microservices.git`

# How To Use
## Build dan Push Image
### Buat file `.env` dan tambahkan token registry:
```bash
echo "TOKEN_REGISTRY=<TOKEN>" > .env
```

### Jalankan perintah untuk build dan push image:
```bash
# Usage: ./build_push_image.sh [-r registry] [-u username] [-i image] [-t tag] [-p path] [-v (verbose)]
./build_push_image.sh

# Mode verbose:
./build_push_image.sh -v

# Menentukan registry dan username:
./build_push_image.sh -r ghcr.io -u ariafatah0711 -i item-app

# Menentukan image, tag, dan path:
./build_push_image.sh -i item-app -t v1 -p .
```

## Menjalankan Aplikasi
### Jalankan aplikasi menggunakan Docker Compose:
```bash
docker-compose up -d
```

### elihat log aplikasi:
```bash
docker-compose logs > log.txt
```

### Mematikan dan menghapus volumes Docker COmposes
```bash
docker-compose down --volume
```