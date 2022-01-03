#!/usr/bin/env bash

set -e

SFDX_JSON=$(cat sfdx-project.json)

for PACKAGE_NAME in $PACKAGE_NAMES
    do
        # parse version nr
        version_nr=$(jq -r --arg PACKAGE_NAME "$PACKAGE_NAME" '.packageDirectories[]| select(.package==$PACKAGE_NAME)["versionNumber"]' <<< "$SFDX_JSON")
        IFS='.' read -r -a version_arr <<< "$version_nr"

        # increase version nrs
        if [ "$UPGRADE_TYPE" = "MAJOR"  ]; then
        version_arr[0]=$((version_arr[0]+1))
        version_arr[1]=0
        version_arr[2]=0
        elif [ "$UPGRADE_TYPE" = "MINOR"  ]; then
        version_arr[1]=$((version_arr[1]+1))
        version_arr[2]=0
        else
        version_arr[2]=$((version_arr[2]+1))
        fi

        # join version_arr
        new_version_nr=$(IFS='.'; printf '%s' "${version_arr[*]}")

        echo "Updating $PACKAGE_NAME from $version_nr ==> $new_version_nr"

        # modify json string
        SFDX_JSON=$(jq --indent 4 --arg PACKAGE_NAME "$PACKAGE_NAME" --arg NEW_VERSION "$new_version_nr" '(.packageDirectories[] | select(.package==$PACKAGE_NAME)["versionNumber"]) |= $NEW_VERSION' <<< "$SFDX_JSON")    
    done
    # write json to file
    echo "$SFDX_JSON" > sfdx-project.json

exit 0;

