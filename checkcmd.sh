#!/bin/sh
while getopts "m:" opt; do
	case $opt in
		m) mail_address=$OPTARG;;
	esac
done
shift $(expr $OPTIND - 1)

cmd=$*
message=$(eval "$cmd" 2>&1)
exit_status=$?

[ "$exit_status" -eq 0 ] && exit

[ -z "$mail_address" ] && echo "$message"
[ -n "$mail_address" ] && echo "$message" | mail -s "$cmd" "$mail_address"

exit $exit_status
