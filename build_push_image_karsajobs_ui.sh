#!/bin/bash
source utils.sh

# ================ Default values ================
ImageName="karsajobs-ui"
ImageTag="latest"
dockerfilePath="."
username="ariafatah0711"
registry="ghcr.io"

# Load TOKEN_REGISTRY dari file .env
export $(grep -v '^#' .envtoken | xargs)

# ==================== START ====================
parse_args "$@"
echo -e "${BLUE}====== BUILD PUSH IMAGES =====${RST}"
echo -e "──────────────────────────────"

clear
echo -e "${BLUE}====== Configuration =====${RST}"
echo -e "──────────────────────────────"
echo "📦 Image Name   : $ImageName"
echo "🔖 Image Tag    : $ImageTag"
echo "📂 Dockerfile   : $dockerfilePath"
echo "👤 Username     : $username"
echo "🌍 Registry     : $registry"
echo "🔊 Verbose Mode : $( [[ "$Verbose" -eq 1 ]] && echo "ON" || echo "OFF" )"

# ==================== Build ====================
echo -e "\n${BLUE}[+] Build Image${RST}"
echo -e "──────────────────────────────"
echo -e "${CYAN}[*] Building image: $ImageName:$ImageTag from $dockerfilePath ${RST}"
if ! run_with_loading docker build -t $ImageName:$ImageTag $dockerfilePath; then
  echo -e "${RED}[Error] Build failed! Exiting...${RST}" >&2
  echo -e "${RED}[*] Check the build log with verbose mode to troubleshoot the issue${RST}"
  exit 1
fi
# run_with_loading $verbose docker build --cache-from=$ImageName:$ImageTag -t $ImageName:$ImageTag $dockerfilePath
# run_with_loading dancok # debug

# # ================= List Images =================
# echo -e "\n${BLUE}[+] List Image${RST}"
# echo -e "──────────────────────────────"
# echo -e "${CYAN}[*] Image List: ${RST}"
# docker images | grep -v "<none>"

# ================= TAG IMAGE =================
NewImage="${registry}/$username/$ImageName:$ImageTag"
echo -e "\n${BLUE}[+] Tagging The Image: $ImageName:$ImageTag to $NewImage ${RST}"
echo -e "──────────────────────────────"
echo -e "\n${CYAN}[*] Tagging the image $ImageName:$ImageTag to $NewImage"
run_with_loading docker tag $ImageName:$ImageTag $NewImage

# ================= Login Registry =================
echo -e "\n${BLUE}[+] Login Registry: $registry ${RST}"
echo -e "──────────────────────────────"
if ! (echo "$TOKEN_REGISTRY" | docker login $registry -u $username --password-stdin); then
    echo -e "${RED}[Error] Login with token failed! Trying interactive login..." >&2
    if ! run_with_loading 1 docker login $registry -u $username; then
        echo -e "${RED}[Error] Interactive login also failed! Exiting..." >&2
        exit 1
    fi
else
    echo -e "${GREEN}[Done] Successfully logged in to $registry!${RST}"
fi

# ================= PUSH IMAGE =================
echo -e "\n${BLUE}[+] PUSH Image $NewImage ${RST}"
echo -e "──────────────────────────────"
# echo -e "\n${CYAN}[*] PUSH Image $NewImage${RST}"
url=https://github.com/users/$username/packages/container/package/$ImageName
echo -e "${CYAN}[INFO] Don't forget to change the visibility ${BLUE}$url${RST} to 'public' if you want the package to be public!${RST}"
run_with_loading docker push $NewImage
echo -e "${GREEN}[INFO] Image push completed successfully!${RST}"