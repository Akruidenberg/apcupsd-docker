#!/bin/sh

LOG_FILE='/var/log/apcaccess.log'
STATUS='STATUS   : '

send_telegram_file() {
    BODY=${1}
    FILE=${2}
    HOSTNAME=`hostname`

    curl -v -4 -F \
        "chat_id=${CHAT_ID}" \
        -F document=@${FILE} \
        -F caption="BorgBackup"$'\n'"        from: #${HOSTNAME}"$'\n\n'"${BODY}" \
        https://api.telegram.org/bot${BOT_TOKEN}/sendDocument \
        > /dev/null 2>&1
}

apcaccess > ${LOG_FILE}

apcaccess_status=$(grep "${STATUS}" ${LOG_FILE})
apcaccess_status=${apcaccess_status#"${STATUS}"}

send_telegram_file "apcaccess executed... ${apcaccess_status}" "${LOG_FILE}"

curl -fsS --retry 5 -o /dev/null ${HEALTH_CHECK}

exit 0
