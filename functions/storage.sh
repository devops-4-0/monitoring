
storage_alarm_state=0

storage_check() {
	current_date=$(date)
	for mnt_path in $MOUNTPATHS; do
		findmnt $mnt_path > /dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			echo "$current_date | $mnt_path path doesn't exist" >> ${script_folder}/storage.log
		else
			storage_used_percentage=$(df -h / | tail -n 1 | awk '{ print $(NF-1) }' | tr -d "%")
			if [[ $storage_used_percentage -ge $STORAGE_LIMIT && $storage_alarm_state -eq 0 ]]; then
				message="🔥️️🔥️️ Alarm 🔥️️🔥️️%0A%0AHostname: ${HOSTNAME} %0A%0AMountpath: $mnt_path %0A%0AUsed: ${storage_used_percentage}%"
				curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d "text=${message}" > /dev/null 2>&1
				storage_alarm_state=1
			fi
			if [[ $storage_used_percentage -lt $STORAGE_LIMIT && $storage_alarm_state -eq 1 ]]; then
				message="✅️️✅️️ Resolved ✅️️✅️️%0A%0AHostname: ${HOSTNAME} %0A%0AMountpath: $mnt_path %0A%0AUsed: ${storage_used_percentage}%"
                                curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d "text=${message}" > /dev/null 2>&1
                                storage_alarm_state=0
			fi
		fi
	done

}

