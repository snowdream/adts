#!/usr/bin/env bash
PACKAGE_NAME="com.autonavi.minimap"
ROBUST=false

check_device()
	{
		DEVICE=`adb devices | awk 'NR>1 {print $1}'`
		if [ -z $DEVICE ]; then
			echo "No device connected, quit."
			exit 1
			return 1
		fi
		return 0
	}

	usage() {
		echo "Usage: $0 <command>"
		echo "    start          -- start monkey"
		echo "       -p <Package Name>          -- Package Name"
		echo "       -r                         -- Robust Test"
		echo "    stop           -- stop monkey"
		echo "    --help|-h      -- help"
		echo
	}

	start_monkey(){
		while getopts "p:r" opt; do
			case $opt in
			p)
			PACKAGE_NAME=$OPTARG ;;
			r)
			ROBUST=true ;;
			\?)
			usage
			exit 1;;
			esac
		done

		echo "Monkey started: $PACKAGE_NAME"
		TIME=`date "+%Y-%m-%d-%H-%M-%S"`
		SDCARD="/mnt/sdcard"
		LOG_DIR="$SDCARD/monkey/$TIME"
		# adb -s ${DEVICE} shell "if [ ! -d "$LOG_DIR"]; then mkdir -p "$LOG_DIR"; fi;"
		adb -s $DEVICE shell "mkdir -p "$LOG_DIR""

		if [[ $ROBUST == true ]]; then
			adb shell "monkey -p $PACKAGE_NAME --ignore-crashes --ignore-timeouts --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 --pct-majornav 0 --pct-anyevent 0 --pct-syskeys 0 --pct-appswitch 80 -v -v -v 1200000000 > $LOG_DIR/monkey  "
		else
			adb shell "monkey -p $PACKAGE_NAME --ignore-crashes --ignore-timeouts --ignore-security-exceptions --pct-trackball 0 --pct-nav 0 --pct-majornav 0 --pct-anyevent 0 --pct-syskeys 0 -v -v -v --throttle 500 1200000000 > $LOG_DIR/monkey  "
		fi

		echo "Collecting screenshot..."
		adb -s $DEVICE shell "screencap -p $LOG_DIR/screenshot.png"
		echo "Collecting traces..."
		adb -s $DEVICE shell "cat /data/anr/traces>$LOG_DIR/traces"
		echo "Collecting cpuinfo..."
		adb -s $DEVICE shell "cat /proc/cpuinfo>$LOG_DIR/cpuinfo"
		echo "Collecting meminfo..."
		adb -s $DEVICE shell "cat /proc/meminfo>$LOG_DIR/meminfo"
		echo "Collecting dumpsys info..."
		adb -s $DEVICE shell "dumpsys meminfo $PACKAGE>$LOG_DIR/dumpmeminfo"
		echo "Collecting bugreport..."
		adb -s $DEVICE shell "bugreport>>$LOG_DIR/bugreport"

		echo "Monkey finished: $PACKAGE_NAME"

	}

	stop_monkey(){
		adb shell ps | awk '/com\.android\.commands\.monkey/ { system("adb shell kill " $2) }'

		echo "Monkey stopped: $PACKAGE_NAME"
	}

	main(){
		check_device
		echo "Device:" $DEVICE

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
