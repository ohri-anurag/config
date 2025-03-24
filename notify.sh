TASKS_FILE=~/tasks.json
if [[ -f $TASKS_FILE ]]
then
  while read task; do
    DUE=$(date +%s -d "$(echo $task | jq -r '.due')")
    if [[ $(date +%s) -gt $DUE ]]
    then
      DESC=$(echo $task | jq -r '.desc')
      XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "Task due!!" "$DESC"
      XDG_RUNTIME_DIR=/run/user/$(id -u) paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    fi
  done < $TASKS_FILE
fi
