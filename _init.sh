#!/bin/bash

#********************************************************************************
# Copyright 2016 IBM
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
#********************************************************************************

set -e
set -x

# Configure extension PATH
EXT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Source git_util sh file
source ${SCRIPTDIR}/git_util.sh

# Get common initialization project
pushd . >/dev/null
cd $SCRIPTDIR
git_retry clone https://github.com/Osthanes/activedeploy_common.git common
popd >/dev/null

# Call common initialization
common/init.sh
