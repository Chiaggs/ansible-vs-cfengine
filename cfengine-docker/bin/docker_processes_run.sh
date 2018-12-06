for cmd in "$@"
do
  file=${cmd%% *}
  base=${file##*/}
  echo "$base, $cmd" >> /var/cfengine/inputs/processes_run.csv
done

/var/cfengine/bin/cf-agent
/var/cfengine/bin/cf-execd -F