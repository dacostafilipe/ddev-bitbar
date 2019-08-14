#!/bin/bash

# Display status of DDEV configs
#
#
# <bitbar.title>DDEV List</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>DA COSTA Filipe</bitbar.author>
#

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

echo "DDEV"
echo "---"

LIST=$(ddev list | sed '1d' | sed -n '/DDEV ROUTER STATUS/q;p')

while read -r line; do

    NAME=$(echo $line | cut -f1 -d" ")
    TYPE=$(echo $line | cut -f2 -d" ")
    SOURCE=$(echo $line | cut -f3 -d" ")
    URI=$(echo $line | cut -f4 -d" ")
    STATUS=$(echo $line | cut -f5 -d" ")

    if [ "$STATUS" == "running" ]; then
      COLOR='green'
    elif [ "$STATUS" == "paused" ]; then
      COLOR='#ffda00'
    else
      COLOR='red'
    fi

    echo "${NAME} | color=${COLOR}"

    if [ "$STATUS" == "running" ]; then
      echo "--${URI} | href='${URI}'"
      echo "--SSH"
      echo "----Web | bash='cd ${SOURCE}; ddev ssh'"
      echo "----Database | bash='cd ${SOURCE}; ddev ssh --service db'"
      echo "-----"
      echo "--Restart | bash='ddev restart ${NAME}'"
      echo "--Pause | bash='ddev pause ${NAME}'"
      echo "--Remove | bash='ddev remove ${NAME}'"
    else
      echo "--Start | bash='ddev start ${NAME}'"
      echo "--Remove | bash='ddev remove ${NAME}'"
    fi

    echo "---"

done <<< "$LIST"
