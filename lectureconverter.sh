#!/bin/bash
# Script to convert KTouch lectures (http://edu.kde.org/ktouch/)
# into plain text files which can be imported by TIPP10 (http://www.tipp10.com)
# Copyright (C) 2014 Arndt von Lucadou (http://www.lucadou.net)
# Permission to copy and modify is granted under the MIT license (http://opensource.org/licenses/MIT)
# Last revised 2014/04/23

hash xml 2>/dev/null || { echo >&2 "XMLStarlet is required to run this script but it's not installed.  Aborting."; exit 1; }
FILE=$1
 
if [ ! -f $FILE -a $FILE ];
then
   echo "Please provide a ktouch.xml-file to parse"; exit 1
fi

LINES=$(xml sel -t -v "/KTouchLecture/Levels/Level/NewCharacters" $FILE)
COUNT=$(echo "$LINES" | wc -l | tr -d ' ')
echo "There are $COUNT entries in $FILE"

DIR=${FILE%.ktouch.xml}
echo "Creating directory $DIR"
mkdir ${FILE%.ktouch.xml}
ITEM=1
PADTOWIDTH=$(test $COUNT -lt 100 && echo 2 || echo 3)

while read -r line; do
    ENTRY=$DIR/$(printf "%0*d\n" $PADTOWIDTH $ITEM)-"$line".txt
    echo "Saving $ENTRY"
    cat >"$ENTRY" <<EOL
$(xml sel -t -m "//Level[$ITEM]" -v "Line" $FILE)
EOL
    let ITEM=ITEM+1
done <<< "$LINES"

exit
