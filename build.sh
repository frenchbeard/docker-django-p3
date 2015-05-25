###############################################################################
#
# File Name         : build.sh
# Created By        : Sébastien Le Corre
# Creation Date     : May 25th, 2015
# Version           : 0.1
# Last Change       : May 25th, 2015 at 21:00:44
# Last Changed By   : Sébastien Le Corre
# Purpose           : Builds django container for specified project, either
#                     hosted on github or another git repository.
#
###############################################################################
#!/usr/bin/env bash

USER=frenchbeard
APP_NAME="django-p3"

function usage {
    echo -e "Usage: $(basename $0) repo_name"
}

if [ $# != 1 ]; then
    usage
    exit 1
else
    echo -e "Retrieving $1..."
    # if [ -d app ]; then
    #     rm -rf app
    # fi
    if ! [ -d app ]; then
        if ! [ $(git clone https://github.com/$1 app) ]; then
            git clone $1 app
        fi
    fi
fi

if [ $(echo $1 | grep '/') ]; then
    APP_NAME=$(echo $1 | awk -F'/' '{print $NF}')
elif [ $(echo $1 | grep ':') ]; then
    APP_NAME=$(echo $1 | awk -F':' '{print $NF}')
fi

docker build -t $USER/$APP_NAME .
