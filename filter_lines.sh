#!/bin/sh
line_count=0

while getopts "c:" opt; do
	case $opt in
		c) line_count=$OPTARG;;
	esac
done
shift $(expr $OPTIND - 1)

input=$(cat)

if [ $(echo "$input" | wc -l) -ge $line_count ]; then
  echo "$input"
fi
