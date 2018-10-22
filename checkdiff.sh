#!/bin/sh

readonly DIR="$HOME/.checkdiff"
mkdir -p $DIR && cd $DIR

cmd=$*
file=$(echo "$cmd" | md5sum | awk '{print $1}')

eval "$cmd" > /tmp/$file
[ -f $file ] || touch $file
diff $file /tmp/$file
status=$?

mv /tmp/$file $file

exit $status
