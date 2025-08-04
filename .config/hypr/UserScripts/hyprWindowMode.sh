#!/usr/bin/env bash

# looks if the active window (in hyprland) is one of the following:
# 	normal		: n	(also adds '[]' around the state letter)
# 	floating	: f	(also adds '()' around the state letter)
# 	maximized	: M
# 	fullscreen	: F	(also for fullscreen and maximized)
# 	empty WS	: h (hyprland)
# 	pseudo		: P
# 	pinned		: p
# 	(or a combination of them)
# 	eg. (M) means a floating window that is maximized
# returns the result in a json that works for waybar
# OR toggles the floating state of the active window, when $1="toggle"
#
# Needs:
# 	hyprland
# 	awk
# 	grep
# 	jq
#
#	by egnrse (https://github.com/egnrse/configs)

# expire time of notifications in ms (see -t in `man notify-send`)
notification_time=1000
# shows hints if 1
show_hints=1
# wait/sleep time between checks [in sec] (0: disables looping)
loopTime=0.01

# this scripts name (used for notifications)
scriptName="hyprWindowMode.sh"

# === package availablility ===
# test if package ($1) is available (notifies the user if not)
available() {
  package=$1
  if ! pacman -Q "${package}" >>/dev/null 2>&1; then
    echo "${scriptName}: package '${package}' missing"
    notify-send "${scriptName}: package '${package}' missing" &
    return 1
  fi
  return 0
}
available hyprland
available awk
available grep
available jq

# === toggle ===
args1=$1
# toggle floating state of the active window
if [ "$args1" == "toggle" ]; then
  clientActive=$(hyprctl activewindow -j)
  out=$(echo "$clientActive" | jq ".address")
  if [ "$out" = "null" ]; then
    # no active window found (eg. empty hyperland window)
    notify-send -u low -a ${scriptName} -t ${notification_time} "${scriptName}: nothing to toggle" &
    exit 1
  fi
  hyprctl dispatch togglefloating
  varExit=$?
  if [ $varExit -eq 0 ]; then
    notify-send -u low -a ${scriptName} -t ${notification_time} "${scriptName}: toggle floating" &
    #notify-send -u low -a ${scriptName} -r 1683 "toggle floating" &
  else
    notify-send -a ${scriptName} "${scriptName}: toggle ERROR?" \
      "'hyprctl dispatch togglefloating' exited with status '$varExit'" &
  fi
  exit 0
fi

# === create JSON ===
# create and return JSON for waybar (given $clientActive)
createJSON() {
  # test if $clientActive is reasonable
  if [ -z "${clientActive}" ]; then
    echo "${scriptName}: active window is empty: '${clientActive}'"
    notify-send "${scriptName}: active window is empty: '${clientActive}'" &
  fi

  textOutput="h"
  tooltip="just hyprland"
  if [ $(echo "$clientActive" | jq ".fullscreen") == "0" ]; then
    textOutput="n"
    tooltip="normal (f0)"
  elif [ $(echo "$clientActive" | jq ".fullscreen") == "1" ]; then
    textOutput="M"
    tooltip="maximized (f1)"
  elif [ $(echo "$clientActive" | jq ".fullscreen") == "2" ]; then
    textOutput="F"
    tooltip="fullscreen (f2)"
  elif [ $(echo "$clientActive" | jq ".fullscreen") == "3" ]; then
    textOutput="F"
    tooltip="maximized and fullscreen (f3)"
  fi
  # pinned
  if [ $(echo "$clientActive" | jq ".pinned") == "true" ]; then
    textOutput="p"
    tooltip="pinned"
  fi
  # Pseudo
  pseudo=0
  if [ $(echo "$clientActive" | jq ".pseudo") == "true" ]; then
    if [ "$textOutput" = "n" ]; then
      # only overwrite 'n'
      textOutput="P"
    fi
    pseudo=1 # used for tooltip
  fi

  # floating
  floating=0 # used for brackets
  if [ $(echo "$clientActive" | jq ".floating") == "true" ]; then
    floating=1
    case "$textOutput" in
    # normal (or pseudo) (overwrite with 'f')
    "n" | "P")
      textOutput="f"
      tooltip="floating"
      ;;
    # maximized/fullscreen/pinned (dont overwrite)
    *)
      tooltip="${tooltip} and floating"
      ;;
    esac
  fi

  # tooltip
  if [ "${pseudo}" -eq 1 ]; then
    tooltip="${tooltip}\n[pseudo]"
  fi
  if [ $show_hints -eq 1 ]; then
    if [ ! "${textOutput}" = "h" ]; then
      # don't show toggle hint on an empty WS
      tooltip="${tooltip}\n<span font_size='80%'>(toggle floating)</span>"
    fi
  fi

  # brackets
  if [ "${floating}" -eq 1 ]; then
    textOutput="(${textOutput})"
  else
    textOutput="[${textOutput}]"
  fi

  # return JSON
  echo "{\"text\":\"${textOutput}\", \"tooltip\":\"${tooltip}\"}"
}

# === first run ===
clientActive=$(hyprctl activewindow -j) # fetch active window (in json format)
returnJSON=$(createJSON)                # create a JSON for waybar given $clientActive
echo ${returnJSON}                      # give JSON to waybar

# for debugging
#notify-send -u low "${returnJSONold}"

# === loop ===
looping=true
if [[ ${loopTime} = 0 ]]; then
  looping=false
fi

while ${looping}; do
  clientActiveOld="${clientActive}"
  clientActive=$(hyprctl activewindow -j) # fetch active window (in json format)

  # only call the 'createJSON' function, if the window changes
  if [ ! "${clientActive}" = "${clientActiveOld}" ]; then
    returnJSONold=${returnJSON}
    returnJSON=$(createJSON) # function call

    # only write to stdout, if the output changes
    if [ ! "${returnJSON}" = "${returnJSONold}" ]; then
      echo ${returnJSON}
    fi
  fi

  sleep ${loopTime}
done
