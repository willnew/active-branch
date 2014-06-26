#!/bin/bash

function contains() {
    declare -a array=("${!1}")
    local seeking=$2
    local isContain=1
    for element in "${array[@]}"; do
        if [[ $element == $seeking ]]; then
            isContain=0
            break
        fi
    done
    return $isContain
}

read -p "Are you under the root directory of your endurance svn working copies?(Y/N)" flag

flag=${flag:-N}
if  [ $flag != "Y" ] && [ $flag != "y" ] ; then 
    echo "Branch operation terminated."
    exit 1
fi

declare -a projs_to_branch=("fnd-webserver-endurance" "endurance-management-service")

working_copies=$(find . -d 1 -type d)
for working_copy in $working_copies; do
    proj=$(svn info $working_copy | grep URL | sed "s/URL: https:\/\///g" | cut -d/ -f 4)
    if contains projs_to_branch[@] "$proj"; then
        echo "original: $working_copy after: $proj" 
    fi
done

