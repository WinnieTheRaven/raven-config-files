#!/bin/sh
# baraction.sh for spectrwm status bar

dte() {
    dte="$(date +"%A, %B %d %l:%M%p")"
    echo -e "$dte"
}

vol() {
    vol=$(mixer vol | awk -F':' '{print $2}')
    echo "VOL: ${vol}%"
}

cpu() {
    cpu_now=$(sysctl -n kern.cp_time)
    
    user=$(echo $cpu_now | awk '{print $1}')
    nice=$(echo $cpu_now | awk '{print $2}')
    sys=$(echo $cpu_now | awk '{print $3}')
    intr=$(echo $cpu_now | awk '{print $4}')
    idle=$(echo $cpu_now | awk '{print $5}')

    total=$(( user + nice + sys + intr + idle ))
    active=$(( user + nice + sys + intr ))
    
    cpu_pct=$(( active * 100 / total ))

    echo "CPU: ${cpu_pct}%"
}

ram() {
    pagesize=$(sysctl -n hw.pagesize)
    total_pages=$(sysctl -n vm.stats.vm.v_page_count)
    free_pages=$(sysctl -n vm.stats.vm.v_free_count)
    inactive_pages=$(sysctl -n vm.stats.vm.v_inactive_count)
    
    total_mb=$(( total_pages * pagesize / 1024 / 1024 ))
    avail_mb=$(( (free_pages + inactive_pages) * pagesize / 1024 / 1024 ))
    used_mb=$(( total_mb - avail_mb ))

    ram_pct=$(( used_mb * 100 / total_mb ))

    echo "RAM: ${used_mb}M / ${total_mb}M (${ram_pct}%)"
}

SLEEP_SEC=5
#this refreshes the info UwUr
while :; do
    echo "$(vol) | $(dte) | $(cpu) | $(ram)"
    sleep $SLEEP_SEC
done
