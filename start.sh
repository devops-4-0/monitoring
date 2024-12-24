#!/bin/bash

HOSTNAME=devops_server
BOT_TOKEN=7946212281:AAGz26rlk5mAH2G3IXtkrat_BDiPRywydGI
CHAT_ID=-4741043043
INTERVAL=5
CPU_LIMIT=30
LOGGING_LEVEL=error
LIMIT_PEAK_COUNT=3

source functions/cpu.sh

init(){
	if [[ ! -d states ]]; then
		mkdir states
	fi
	touch states/running
}

init

while [[ -f states/running ]]; do
	cpu_check
	sleep $INTERVAL
done

