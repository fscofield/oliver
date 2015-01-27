 #/bin/bash

EXT='php'
DIR='.'

#!/bin/bash
while [[ $# > 1 ]]
do
key="$1"

case $key in
	-d|--directory)
    DIR="$2"
    shift
    ;;
    -e|--extension)
    EXT="$2"
    shift
    ;;
    --default)
    DEFAULT=YES
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift
done
echo searching "for unused .${EXT} files in" `cd "${DIR}"; pwd`...
PHP_FILES=$(find ${DIR} -name "*.${EXT}" )

for FILE in $PHP_FILES; do
    short_name=`basename $FILE`
    filename="${short_name%.*}"
    git grep --quiet $short_name 1>/dev/null
    if [ "$?" == "1" ]; then
    	rev_history=$(git log --pretty=format:"%h%x09%an%x09%ad%x09$a" -1 -- $FILE | awk '{printf "%3s %1s %3s %3s\n", $5, $8, $2, $3}')
        echo "Should delete: $FILE (last edit: $rev_history)"
    fi
done;