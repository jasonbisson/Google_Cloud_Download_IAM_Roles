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

export tempdir=/tmp
export dataset=gcp_iam_roles
export table=predefined_roles
export project_id=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export bucket=${project_id}-${table}

function download_predefined_roles () {
printf "Exporting predefined roles can take some time since there are over 500+ roles (10-15 minutes)\n"

for x in $(gcloud iam roles list --format 'value(name)')
do
    role=$(echo ${x} |sed 's|roles/||g')
    printf "Exporting role ${x} to $tempdir/${role}.json\n"
    gcloud iam roles describe ${x} --format json | jq -c > $tempdir/${role}.ndjson
done

}

function create_bucket () {
    exists=$(gsutil ls -b gs://$bucket)
    if [  -z "$exists" ]; then
        gsutil mb gs://${bucket}
    fi
}

function create_dataset () {
    exists=$(bq ls ${dataset})
    if [  -z "$exists" ]; then
        bq mk ${dataset}
    fi
}

function upload_local_files () {
    gsutil -m cp ${tempdir}/*.ndjson gs://${bucket}
}

function load_data () {
    bq load --project_id=${project_id} --source_format=NEWLINE_DELIMITED_JSON --autodetect --replace --time_partitioning_type=DAY ${dataset}.${table} gs://${bucket}/*.ndjson
}

#download_predefined_roles
create_bucket
create_dataset
upload_local_files
load_data
