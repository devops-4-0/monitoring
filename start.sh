#!/bin/bash

script_folder=$(dirname $(readlink -f "$0"))

source ${script_folder}/functions/cpu.sh
source ${script_folder}/monitoring.conf

init(){
	if [[ ! -d ${script_folder}/states ]]; then
		mkdir ${script_folder}/states
	fi
	touch ${script_folder}/states/running
}

init

while [[ -f ${script_folder}/states/running ]]; do
	cpu_check
	sleep $INTERVAL
done

