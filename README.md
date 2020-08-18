# Export GCP Predefined roles

This repository contains a simple bash script to export the GCP predefined IAM roles into the temp directory. The goal of this script is to provide method to easily review the permissions in each role for possible custom roles.
 
## Install
Download the latest gcloud SDK
https://cloud.google.com/sdk/docs/

## Permission to export roles
iam.roles.get
iam.roles.list

## Usage

### Update default export directory /tmp 
```
If needed use your favorite editor or IDE to update the default folder location which is /tmp.
```
### Run the export script and be patient
```
$ export_predefined_roles.sh

```
### Run the export and load into Big Query for Analysis 
```
$ load_predefined_roles_into_bq.sh

## External Documentation

[Understanding IAM roles](https://cloud.google.com/iam/docs/understanding-roles)

