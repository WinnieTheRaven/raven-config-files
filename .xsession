#! /bin/sh

setxkbmap -layout latam

pipewire &
wireplumber &
pipewire-pulse &

exec dbus-launch --exit-with-session spectrwm

/home/raven/.config/polybar/launch.sh &
