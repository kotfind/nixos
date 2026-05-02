#!/usr/bin/env bash

if [ "$(playerctl status)" == "Playing" ]
then
    playerctl metadata -f '{{artist}} — {{title}}'
else
    echo -n '󰓛'
fi
