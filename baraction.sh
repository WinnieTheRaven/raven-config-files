#!/bin/ksh
# baraction.sh for spectrwm status bar

dte() {
    d="$(date +"%A, %B %d %l:%M%p")"
    echo -e "$d"
}

vol() {
    v=$(mixerctl -n outputs.master)
    echo -e "VOL: $v"
}

SLEEP_SEC=5

while :; do
    echo "$(vol) | $(dte)"
    sleep $SLEEP_SEC
done