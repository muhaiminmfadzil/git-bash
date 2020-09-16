#!/bin/bash

# receive argument
ARG=$1
echo $ARG

# get current git branch
CURRENTBRANCH=$(git branch --show-current 2>&1)
echo $CURRENTBRANCH

pushandcheckout() {
    echo "this is push checkout"
    git push && git checkout dev && aaa && git branch -D $CURRENTBRANCH
    return 1
}

pushandnewbranch() {
    echo "this is push new branch"
}

if [ "$ARG" = "$CURRENTBRANCH" ]; then
    echo "You already on $ARG branch"
    exit 1
elif [ "$ARG" = "dev" ]; then
    pushandcheckout
else
    pushandnewbranch
fi
