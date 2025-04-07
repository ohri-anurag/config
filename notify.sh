TASKS_FILE=~/tasks.json
if [[ -f $TASKS_FILE ]]
then
  jq '.[]' -c $TASKS_FILE | while read task; do
    DUE=$(date +%s -d "$(echo $task | jq -r '.due')")
    if [[ $(date -u +%s) -gt $DUE ]]
    then
      DESC=$(echo $task | jq -r '.desc')
      ID=$(echo $task | jq -r '.id')
      XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send --app-name "TODO" -t 0 "Task due: $ID" "$DESC"
      XDG_RUNTIME_DIR=/run/user/$(id -u) paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    fi
  done
fi
