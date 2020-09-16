#!/bin/bash

# receive argument
ARG=$1
echo $ARG

# get current git branch
CURRENTBRANCH=$(git branch --show-current 2>&1)

pushandcheckout() {
    echo -e "--Push current branch\n" &&
        git push &&
        echo -e "--Checkout dev\n" &&
        git checkout dev &&
        echo "--Pull dev\n" &&
        git pull &&
        echo "--Delete branch $CURRENTBRANCH\n" &&
        git branch -D $CURRENTBRANCH &&
        echo "\nDone!"
    return 1
}

pushandnewbranch() {
    echo "this is push new branch"
    return 1
}

if [ "$ARG" = "$CURRENTBRANCH" ]; then
    echo "You already on $ARG branch"
    exit 1
elif [ "$ARG" = "dev" ] || [ "$ARG" = "" ]; then
    pushandcheckout
else
    pushandnewbranch
fi
