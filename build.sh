###############################################################################
#
# File Name         : build.sh
# Created By        : Sébastien Le Corre
# Creation Date     : May 25th, 2015
# Version           : 0.1
# Last Change       : May 26th, 2015 at 01:08:21
# Last Changed By   : Sébastien Le Corre
# Purpose           : Builds django container for specified project, either
#                     hosted on github or another git repository.
#
###############################################################################
#!/usr/bin/env bash

USER=frenchbeard
APP_NAME=''

function usage {
    echo -e "Usage: $(basename $0) {github_repo_name|git_repo_url}"
}

if [ $# -ne 1 ] ; then
    if ! [ -d app ]; then
        usage
        exit 1
    else
        if [ "$(cd app && git remote show origin | grep Fetch | grep ':')" != "" ]; then
            APP_NAME=$(cd app && git remote show origin | grep Fetch | \
            awk -F':' '{print $NF}' | awk -F'/' '{print $NF}')
        elif [ "$(cd app && git remote show origin | grep Fetch | grep '/')" != "" ]; then
            APP_NAME=$(cd app && git remote show origin | grep Fetch | \
                awk -F'/' '{print $NF}')
        fi
    fi
else
    if [ $(echo $1 | grep ':') ]; then
        APP_NAME=$(echo $1 | awk -F':' '{print $NF}' | awk -F'/' '{print $NF}')
    elif [ $(echo $1 | grep '/') ]; then
        APP_NAME=$(echo $1 | awk -F'/' '{print $NF}')
    fi
    echo -e "Retrieving $APP_NAME..."
    if [ -d app ]; then
        cd app && git pull origin master
    else
        if ! [ $(git clone https://github.com/$1 app 2> /dev/null) ]; then
            git clone $1 app
        fi
    fi
fi

docker build -t $USER/$APP_NAME .
