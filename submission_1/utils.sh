#!/bin/bash
RST="\033[0m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"

# argument
parse_args() {
    Verbose=0  # Default verbose mati

    while getopts "r:u:i:t:p:v" opt; do
        case "$opt" in
            r) registry=$OPTARG ;;   # Registry
            u) username=$OPTARG ;;   # Username
            i) ImageName=$OPTARG ;;  # Image Name
            t) ImageTag=$OPTARG ;;   # Image Tag
            p) dockerfilePath=$OPTARG ;; # Dockerfile Path
            v) Verbose=1 ;;          # Verbose Mode
            ?) echo "Usage: $0 [-r registry] [-u username] [-i image] [-t tag] [-p path] [-v (verbose)]"
               exit 1 ;;
        esac
    done

    export Verbose
}

# prompt input
prompt_input() {
    local prompt_text="$1"
    local default_value="$2"
    local input

    read -p " |_ $prompt_text ($default_value): " input
    echo "${input:-$default_value}"
}

# command with loading
run_with_loading() {
    local verbose_flag=0
    if [[ "$1" =~ ^[0-1]$ ]]; then
        verbose_flag=$1
        shift
    fi

    local start_time=$(date +%s)  # Waktu mulai

    # Nonaktifkan input sementara
    stty -echo -icanon  

    if [[ "$Verbose" -eq 1 ||  "$verbose_flag" -eq 1 ]]; then
        echo -e "${BLUE}[INFO]\033[0m Running in verbose mode..."
        "$@"
        local exit_code=$?
        stty sane  # Balikin input keyboard
        while read -t 0.1 -n 1; do : ; done
        if [[ $exit_code -eq 0 ]]; then
            # echo -e "\r${GREEN}✅ Done '$@' in ${duration}s${RST}"
            echo -e "\r${GREEN}[Done] '$@' in ${duration}s${RST}"
        else
            echo -e "\r${RED}[Error] '$@' failed with exit code $exit_code!${RST}"
        fi
        return $exit_code
    fi

    # Jalankan command di background, simpan PID
    "$@" > /dev/null 2>&1 & PID=$!

    # Animasi Spinner
    local chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")  # Spinner animasi
    local i=0

    echo -ne "${YELLOW}Processing\033[0m "

    # trap "stty sane; echo -e '\n❌ Process interrupted!'; exit 1" SIGINT  # Tangkap Ctrl + C
    trap "stty sane; echo -e '\n[Error] Process interrupted!'; exit 1" SIGINT  # Tangkap Ctrl + C

    while kill -0 $PID 2>/dev/null; do 
        echo -ne "\r${YELLOW}Processing ${chars[i]}\033[0m"
        sleep 0.1
        ((i = (i + 1) % ${#chars[@]}))
    done

    # Tunggu proses selesai dan cek statusnya
    wait $PID
    local exit_code=$?

    local end_time=$(date +%s)  # Waktu selesai
    local duration=$((end_time - start_time))

    # Kembalikan input keyboard ke normal
    stty sane

    # Buang semua input yang tertahan
    while read -t 0.1 -n 1; do : ; done

    if [[ $exit_code -eq 0 ]]; then
        # echo -e "\r${GREEN}✅ Done '$@' in ${duration}s${RST}"
        echo -e "\r${GREEN}[Done] '$@' in ${duration}s${RST}"
    else
        # echo -e "\r${RED}❌ Error '$@' failed with exit code $exit_code!${RST}"
        echo -e "\r${RED}[Error] '$@' failed with exit code $exit_code!${RST}"
    fi

    return $exit_code
}