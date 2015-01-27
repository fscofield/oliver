 #/bin/bash

EXT='php'
DIR='.'
OMIT=''
while getopts ":d:e:o:" opt
   do
     case $opt in
        d ) DIR=$OPTARG;;
        e ) EXT=$OPTARG;;
        o ) OMIT=$OPTARG;;
     esac
done

for subdir in $OMIT;do
    OMIT_PATH+=" -path $subdir -o "
done

OMIT_PATH=${OMIT_PATH:0:${#OMIT_PATH}-3}

echo searching "for unused .${EXT} files in" `cd "${DIR}"; pwd`...
echo "excluding files in $OMIT"
FILES=$(find ${DIR} -not \( ${OMIT_PATH} \) -name "*.${EXT}" )

for FILE in $FILES; do
    short_name=`basename $FILE`
    filename="${short_name%.*}"
    git grep --quiet $short_name 1>/dev/null
    if [ "$?" == "1" ]; then
        rev_history=$(git log --pretty=format:"%h%x09%an%x09%ad%x09$a" -1 -- $FILE | awk '{printf "%3s %1s %3s %3s\n", $5, $8, $2, $3}')
        echo "Should delete: $FILE (last edit: $rev_history)"
    fi
done;