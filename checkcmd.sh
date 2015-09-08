#!/bin/sh
while getopts "cm:" opt; do
	case $opt in
		c) check=1;;
		m) mail=$OPTARG;;
	esac
done
shift $(expr $OPTIND - 1)

cmd=$*
msg=$(eval "$cmd" 2>&1)
code=$?
msg=$(echo "$msg" | sed '/\r/d')

[ ! -z "$check" ] && [ "$code" -eq 0 ] && exit $code
[   -z "$msg" ] && exit $code
[   -z "$mail" ] && echo "$msg"
[ ! -z "$mail" ] && echo "$msg" | mail -s "$cmd" "$mail"

exit $code
