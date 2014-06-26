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

declare -a projs_to_branch=("event-management-service" "endurance-management-service")

working_copies=$(find . -d 1 -type d)
for working_copy in $working_copies; do
    proj_URL=$(svn info $working_copy | grep URL | sed "s/URL:\ //g" )
    proj=$(echo $proj_URL | sed 's/https:\/\///g' | cut -d/ -f 4)
    if contains projs_to_branch[@] "$proj"; then
        echo "original: $working_copy after: $proj" 
        # 1. branch
        # add if...else... to handle FWE
        current_version=$(cat "$working_copy/build.xml" | grep "name=\"ivy.deliver.revision\"" | cut -d '"' -f 4 | cut -d "-" -f 1 | cut -d "." -f 1-3)
        new_version_number=$(echo $current_version | cut -d "." -f 2 | awk '{print $1 +1}')
        new_version=$(echo $current_version | sed 's/\.[0-9]*\./\.'${new_version_number}'\./g')
        echo $(echo $proj_URL | sed 's/trunk/branches\/'$new_version'/g')
        # 2. version bump
    fi
done

