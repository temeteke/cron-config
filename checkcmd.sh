#!/bin/sh
while getopts "cm:" opt; do
	case $opt in
		c) check=1;;
		m) mail=$OPTARG;;
	esac
done
shift $(expr $OPTIND - 1)

cmd="$*"
msg=$(eval $cmd 2>&1)
code=$?

[ ! -z "$check" ] && [ "$code" -eq 0 ] && exit
[   -z "$msg" ] && exit
[   -z "$mail" ] && echo "$msg"
[ ! -z "$mail" ] && echo "$msg" | mail -s "$cmd" "$mail"