#!/bin/bash

#********************************************************************************
#   (c) Copyright 2016 IBM Corp.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#********************************************************************************

# uncomment the next line to debug this script
#set -x

# this script is not in Osthanes/utilities because then git would be needed to access it
# and it contains the git retry code.  not renamed for compatibility with existing pipelines

# use this function to add retries to a command that returns non-zero on fail
with_retry() {
    if [[ $DEBUG -eq 1 ]]; then
        local START_TIME=$(date +"%s")
    fi
    local RETRY_CALL="$*"
    echo $RETRY_CALL
    $RETRY_CALL
    local RETRY_RC=$?
    local CURRENT_RETRY_COUNT=0
    if [ -z "$CMD_RETRY" ]; then
        local CMD_RETRY=5
    fi
    while [[  $CURRENT_RETRY_COUNT -lt $CMD_RETRY && $RETRY_RC -ne 0 ]]; do
        ((CURRENT_RETRY_COUNT++))
        echo -e "${label_color}${1} command failed; retrying in 3 seconds${no_color} ($CURRENT_RETRY_COUNT of $CMD_RETRY)"
        sleep 3
        echo $RETRY_CALL
        $RETRY_CALL
        RETRY_RC=$?
    done

    if [ $RETRY_RC -ne 0 ]; then
        echo -e "${red}${1} command failed: $RETRY_CALL${no_color}" | tee -a "$ERROR_LOG_FILE"
    fi

    if [[ $DEBUG -eq 1 ]]; then
        local END_TIME=$(date +"%s")
        export LAST_CMD_TIME=$(($END_TIME-$START_TIME))
        echo -e "Cmd '$RETRY_CALL' runtime of `date -u -d @\"$LAST_CMD_TIME\" +'%-Mm %-Ss'`"
    fi

    return $RETRY_RC
}

# use this function to help avoid pipeline problems when accessing git repositories
git_retry() {
    if [ -n "$GIT_RETRY" ]; then
        local SAVE_CMD_RETRY=$CMD_RETRY
        export CMD_RETRY=$GIT_RETRY
    fi
    with_retry "git" $*
    local RETURN_RC=$?
    if [ -n "$SAVE_CMD_RETRY" ]; then
        export CMD_RETRY=$SAVE_CMD_RETRY
    fi
    return $RETURN_RC
}

#export functions
export -f git_retry
export -f with_retry
