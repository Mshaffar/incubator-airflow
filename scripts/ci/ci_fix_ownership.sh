#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#
# Fixes ownership for files created inside container (files owned by root will be owned by host user)
#

set -euo pipefail
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=scripts/ci/_utils.sh
. "${MY_DIR}/_utils.sh"

basic_sanity_checks

script_start

export PYTHON_VERSION=3.5

export AIRFLOW_CI_IMAGE=\
${DOCKERHUB_USER}/${DOCKERHUB_REPO}:${AIRFLOW_CONTAINER_BRANCH_NAME}-python${PYTHON_VERSION}-ci

HOST_USER_ID="$(id -ur)"
export HOST_USER_ID

HOST_GROUP_ID="$(id -gr)"
export HOST_GROUP_ID

docker-compose \
    -f "${MY_DIR}/docker-compose/base.yml" \
    -f "${MY_DIR}/docker-compose/local.yml" \
    run airflow-testing /opt/airflow/scripts/ci/in_container/run_fix_ownership.sh

script_end
