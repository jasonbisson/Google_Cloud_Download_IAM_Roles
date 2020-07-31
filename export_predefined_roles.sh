#!/usr/bin/env bash
#set -x
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

tempdir=/tmp

printf "Exporting predefined roles can take some time since there are over 500+ roles (10-15 minutes)\n"

for x in $(gcloud iam roles list --format 'value(name)')
do
    role=$(echo ${x} |sed 's|roles/||g')
    printf "Exporting role ${x} to $tempdir/${role}.json\n"
    gcloud iam roles describe ${x} --format json >  $tempdir/${role}.json
done