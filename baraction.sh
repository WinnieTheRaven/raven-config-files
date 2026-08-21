#!/bin/ksh
# baraction.sh for spectrwm status bar

dte() {
    dte="$(date +"%A, %B %d %l:%M%p")"
    echo -e "$dte"
}

vol() {
    vol=$(mixerctl -n outputs.master)
    echo -e "VOL: $vol"
}

SLEEP_SEC=5
#this refreshes the info UwUr
while :; do
    echo "$(vol) | $(dte)"
    sleep $SLEEP_SEC
done
