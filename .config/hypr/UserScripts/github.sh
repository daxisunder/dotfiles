#!/bin/bash

token=$(cat "${HOME}/.config/gh/notifications.token")
count=$(curl -u daxisunder:${token} https://api.github.com/notifications | jq '. | length')

tooltip="You have $count notifications"
class="notification"

if [[ "$count" != "0" ]]; then
  echo "{'text':'$count','tooltip':'$tooltip','class':'$class'}"
fi
