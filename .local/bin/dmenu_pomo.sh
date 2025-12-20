#!/bin/bash

choice=$(printf "Pause\nStart\nStop" | wmenu -i -N 000000 -f "MonoLisa 13" -p "Pomo")
pomo ${choice,,} > /dev/null 2>&1
