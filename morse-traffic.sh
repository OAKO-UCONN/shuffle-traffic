#/bin/bash
#Move to validation and then pull request to master
#Morse traffic generator
#Usage message:
[ $# -eq 0 ] && { echo -e "Usage: $0 [IP address] [time(seconds)] '[morse_code]' \n IP address of IPERF3 server \n Time is the trasnmission's duration of every code \n morse_code should be put between ''. Accepter caracters dot(.) dash (-) back slash (/) space ( )  \nS O S Ex: $0 127.0.0.1 5 '... / --- / ...'"; exit 1; }

#Set vars
server=$1
timex=$2
morse=$3

echo $num_char

echo -e "The following message $morse will be sent to iperf3 server at IP: $server in intervals of $timex [s]. \nThis will take $(($timex * ${#morse})) [s]"

#Set double duration for dash caracter
timex2=$((timex * 2))
max=200m #max bandwidth

for (( i=0; i<${#morse}; i++ )); do
  #echo "${morse:$i:1}" #for debug
  sleep 1 # stopable point
  var=${morse:$i:1}

  if [[ "$var" == "."  ]]; then

    iperf3 -c $server -Z -t $timex -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == "-" ]]; then
    iperf3 -c $server -Z -t $timex2 -b $max >/dev/null & #UPLOAD
    iperf3 -c $server -R -Z -t $timex2 -b $max -p 5202 >/dev/null #download
    wait

  elif [[ "$var" == " "  ]]; then
    sleep $timex # sleep interval for space caracter
    wait
  sleep $timex # sleep interval between caracters

  elif [[ "$var" == "/"  ]]; then
    #echo "/"
    sleep $timex # sleep interval for space caracter
  wait
fi
sleep $timex # sleep interval between caracters
done
exit
