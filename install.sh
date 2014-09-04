#!/bin/bash -

FILE=gitclear.sh
USER=$(stat -f %Su .)
GROUP=$(stat -f %Sg .)
SCRIPT=gitclear
SCRIPT_LOCATION=/usr/local/bin/

arr=$(echo $PATH | tr ":" "\n")
result="0"

for i in $arr; do
    if [ "$i" == "/usr/local/bin" ]; then
        result="1"
    fi
done

if [ "$result" == "0" ]; then
    echo "'$SCRIPT_LOCATION'" should be added to the \$PATH list.
    exit
fi

sudo cp $FILE $SCRIPT_LOCATION
cd $SCRIPT_LOCATION
sudo mv $FILE $SCRIPT
sudo chown $USER\:$GROUP $SCRIPT
sudo chmod u+x $SCRIPT
cd
