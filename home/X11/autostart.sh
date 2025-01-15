#!/usr/bin/env bash

run() {
    for pid in $(pgrep -f $1); do
        kill -9 "$pid"
    done
    $* &
}

run xss-lock xlock

run batsignal

run lxqt-policykit-agent

run fcitx5

SXHKD_SHELL=sh run sxhkd

run ~/.config/lemonbar/lemonbar.sh

mkdir -p /tmp/downloads /tmp/screenshots
