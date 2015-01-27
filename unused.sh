 #/bin/bash

EXT='php'
DIR='.'
OMIT=''
REV="0"
while getopts ":d:e:o:r" opt
   do
     case $opt in
        d ) DIR=$OPTARG;;
        e ) EXT=$OPTARG;;
        o ) OMIT=$OPTARG;;
        r ) REV="1";;
     esac
done

for subdir in $OMIT;do
    OMIT_PATH+=" -not ( -path $DIR/$subdir -prune ) "
done

FILES=$(find ${DIR} $OMIT_PATH -name "*.${EXT}" )
echo "searching for matching files..."
echo "excluding files in $OMIT..."
echo ${#FILES} files collected...
echo searching "for unused .${EXT} files in" `cd "${DIR}"; pwd`...

for FILE in $FILES; do
    short_name=`basename $FILE`
    filename="${short_name%.*}"
    git grep --quiet $short_name 1>/dev/null
    if [ "$?" == "1" ]; then
        if [ "$REV" == "1" ]; then
            history=$(git log --pretty=format:"%h%x09%an%x09%ad%x09$a" -1 -- $FILE | awk '{printf "%3s %1s %3s %3s\n", $5, $8, $2, $3}')
            rev_history="(last edit: ${history})"
        fi
        echo "Should delete: $FILE $rev_history"
    fi
done;