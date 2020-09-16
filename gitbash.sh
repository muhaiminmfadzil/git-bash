#!/bin/bash

# receive argument
NEWBRANCHNAME=$1
NEWBRANCHONLYNAME=$2
REMOTENAME=$3

# get current git branch
CURRENTBRANCH=$(git branch --show-current 2>&1)

# set default value for $NEWBRANCHNAME
if [ "$NEWBRANCHNAME" = "" ]; then
    NEWBRANCHNAME="dev"
fi

# set default value for $REMOTENAME
if [ "$REMOTENAME" = "" ]; then
    REMOTENAME="origin"
fi

# checkout to dev and delete current branch only
pushcheckoutdelete() {
    echo -e "\n--Checkout dev\n" &&
        git checkout dev &&
        echo -e "\n--Pull dev\n" &&
        git pull &&
        echo -e "\n--Delete branch $CURRENTBRANCH\n" &&
        git branch -D $CURRENTBRANCH &&
        echo -e "\nDone!"
    return 1
}

# checkout to dev and create new branch only
pushnewbranchonly() {
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

# checkout to dev, pull, delete current branch, create new branch and set upstream
all() {
    echo -e "\n--Checkout dev\n" &&
        git checkout dev &&
        echo -e "\n--Pull dev\n" &&
        git pull &&
        echo -e "\n--Delete branch $CURRENTBRANCH\n" &&
        git branch -D $CURRENTBRANCH &&
        echo -e "\n--Create new branch named $NEWBRANCHNAME\n" &&
        git checkout -b $NEWBRANCHNAME &&
        echo -e "\n--Push & upstream new branch $NEWBRANCHNAME to Github $REMOTENAME\n" &&
        git push -u origin $NEWBRANCHNAME &&
        echo -e "\nDone!"
    return 1
}

if [ "$NEWBRANCHNAME" = "$CURRENTBRANCH" ]; then
    echo "You already on $NEWBRANCHNAME branch"
    exit 1
elif [ "$NEWBRANCHNAME" = "dev" ]; then
    pushcheckoutdelete
elif [ "$NEWBRANCHNAME" = "-newonly" ]; then
    pushnewbranchonly
else
    all
fi
