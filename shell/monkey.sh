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
  adb shell "monkey -p ${PACKAGE_NAME} --ignore-crashes --ignore-timeouts --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 --pct-majornav 0 --pct-anyevent 0 -v -v -v --throttle 500 1200000000 > /storage/sdcard0/monkey_log.txt"
}

stop_monkey(){
  adb shell ps | awk '/com\.android\.commands\.monkey/ { system("adb shell kill " $2) }'
}

main(){
check_device

if [ $# == "0" ]; then
  usage
  exit
fi

while (( $# )); do
case $1 in
--help|-h)
  usage
  exit
  ;;
-p) 
  shift; 
  PACKAGE_NAME=$1 
  ;;
start)
  start_monkey
  ;;
stop)
  stop_monkey
  exit
  ;;
*) # execute 'advanced command' by function name
  adb shell monkey $@
  ;;
esac
shift
done  
}

main $@
