#!/bin/bash

# receive argument
NEWBRANCHNAME=$1
NEWBRANCHONLYNAME=$2
REMOTENAME=$3

# get current git branch
CURRENTBRANCH=$(git branch --show-current 2>&1)

# set default value for $REMOTENAME
if [ "$REMOTENAME" = "" ]; then
    REMOTENAME="origin"
fi

# push, checkout to dev and delete current branch only
pushcheckoutdelete() {
    echo -e "\n--Push current branch\n" &&
        git push &&
        echo -e "\n--Checkout dev\n" &&
        git checkout dev &&
        echo -e "\n--Pull dev\n" &&
        git pull &&
        echo -e "\n--Delete branch $CURRENTBRANCH\n" &&
        git branch -D $CURRENTBRANCH &&
        echo -e "\nDone!"
    return 1
}

# push, checkout to dev and create new branch only
pushnewbranchonly() {
    echo -e "\n--Push current branch\n" &&
        git push &&
        echo -e "\n--Checkout dev\n" &&
        git checkout dev &&
        echo -e "\n--Pull dev\n" &&
        git pull &&
        echo -e "\n--Create new branch named $NEWBRANCHONLYNAME\n" &&
        git checkout -b $NEWBRANCHONLYNAME &&
        echo -e "\n--Push & upstream new branch $NEWBRANCHONLYNAME to Github $REMOTENAME\n" &&
        git push -u origin $NEWBRANCHONLYNAME &&
        echo -e "\nDone!"
    return 1
}

pushandnewbranch() {
    echo "this is push new branch"
    return 1
}

if [ "$NEWBRANCHNAME" = "$CURRENTBRANCH" ]; then
    echo "You already on $NEWBRANCHNAME branch"
    exit 1
elif [ "$NEWBRANCHNAME" = "dev" ] || [ "$NEWBRANCHNAME" = "" ]; then
    pushcheckoutdelete
elif [ "$NEWBRANCHNAME" = "-newonly" ]; then
    pushnewbranchonly
else
    pushandnewbranch
fi
