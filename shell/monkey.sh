#!/usr/bin/env bash
PACKAGE_NAME="com.autonavi.minimap"

check_device()
{
	DEVICE=`adb devices | awk 'NR>1 {print $1}'`
	if [ -z ${DEVICE} ]; then
		echo "No device connected, quit."
    exit 1
		return 1
	else
		return 0
	fi
	return ${DEVICE}
}

usage() {
  echo "Usage: $0 <command>"
  echo "    start          -- start monkey"
  echo "       -p <Package Name>          -- Package Name"
  echo "    stop           -- stop monkey"
  echo "    --help|-h      -- help"
  echo
}

start_monkey(){
  while getopts "p:" opt; do
    case $opt in
        p)
          PACKAGE_NAME=$OPTARG ;;
        \?) echo "Invalid param" ;;
    esac
  done
 
  echo "Start Monkey: ${PACKAGE_NAME}"


  adb shell "monkey -p ${PACKAGE_NAME} --ignore-crashes --ignore-timeouts --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 --pct-majornav 0 --pct-anyevent 0 -v -v -v --throttle 500 1200000000 > /storage/sdcard0/monkey_log.txt  &"
}

stop_monkey(){
	echo "Stop Monkey: ${PACKAGE_NAME}"

  adb shell ps | awk '/com\.android\.commands\.monkey/ { system("adb shell kill " $2) }'
}

main(){
check_device

if [ $# == "0" ]; then
  usage
  exit
fi

if [[ $1 == "--help" ]] ||  [[ $1 == "-h" ]] ; then
	usage
elif [[ $1 == "start"  ]]; then
	shift
	start_monkey $@
elif [[ $1 == "stop"  ]]; then
	stop_monkey
else
	usage
fi
}

main $@
