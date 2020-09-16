#!/bin/bash

# variables set
NEWBRANCHONLY=false
REMOTENAME="origin"

# get current git branch
CURRENTBRANCH=$(git branch --show-current 2>&1)

usage() {
    echo "Help function"
    return 1
}

while getopts ":h" opt; do
    case ${opt} in
    h) # help
        usage
        exit 0
        ;;
    \?) # invalid options
        usage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

subcommand=$1
shift # Remove 'next' from the argument list
case "$subcommand" in
# Parse options to the next sub command
next)
    NEWBRANCHNAME=$1
    shift # Remove 'branch name' from the argument list

    # Process new branch options
    while getopts ":nr:" opt; do
        case ${opt} in
        r) # remote branch name
            REMOTENAME=$OPTARG
            ;;
        n) # new branch only (not delete current branch)
            NEWBRANCHONLY=true
            ;;
        \?) # invalid options
            echo "Invalid Option: -$OPTARG" 1>&2
            exit 1
            ;;
        :) # argument required option
            echo "Invalid Option: -$OPTARG requires an argument" 1>&2
            exit 1
            ;;
        esac
    done
    shift $((OPTIND - 1))
    ;;
esac

# checkout dev and pull
devrun() {
    echo -e "\n--Checkout dev\n" &&
        git checkout dev &&
        echo -e "\n--Pull dev\n" &&
        git pull
    return 0
}

# delete current branch
deletecurrentbranch() {
    echo -e "\n--Delete branch $CURRENTBRANCH\n" &&
        git branch -D $CURRENTBRANCH
    return 0
}

# create new branch and set upstream
createnewbranchsetupstream() {
    echo -e "\n--Create new branch named $NEWBRANCHNAME\n" &&
        git checkout -b $NEWBRANCHNAME &&
        echo -e "\n--Push & upstream new branch $NEWBRANCHNAME to Github $REMOTENAME\n" &&
        git push -u origin $NEWBRANCHNAME
    return 0
}

# checkout to dev and delete current branch only
runcheckoutdelete() {
    echo "run check out delete"
    devrun &&
        deletecurrentbranch
    echo -e "\nDone!"
    return 0
}

# checkout to dev and create new branch only
runnewbranchonly() {
    echo "run new branch only"
    devrun &&
        createnewbranchsetupstream
    echo -e "\nDone!"
    return 0
}

# checkout to dev, pull, delete current branch, create new branch and set upstream
runall() {
    echo "run all"
    devrun &&
        if [ "$CURRENTBRANCH" = "dev" ]; then
            createnewbranchsetupstream
        else
            deletecurrentbranch &&
                createnewbranchsetupstream
        fi
    echo -e "\nDone!"
    return 0
}

echo $NEWBRANCHNAME
echo $NEWBRANCHONLY
echo $REMOTENAME

if [ "$NEWBRANCHNAME" = "" ]; then
    echo "ERROR : Branch name is required!"
    exit 1
fi

# run
if [ "$NEWBRANCHNAME" = "$CURRENTBRANCH" ]; then
    echo "You already on $NEWBRANCHNAME branch"
    exit 0
elif [ "$NEWBRANCHNAME" = "dev" ]; then
    runcheckoutdelete
elif [ "$NEWBRANCHONLY" = true ]; then
    runnewbranchonly
else
    runall
fi
