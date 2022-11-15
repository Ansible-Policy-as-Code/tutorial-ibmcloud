#!/bin/sh
#
# This pre-commit script will update policies/POLICIES.md using
# Jinja2 template engine. The policies are read from Rego metadata
# from all Rego files in policies/* directory. 
#

# Check if OPA is installed
[[ $(type -P "opa") ]]  ||
    { echo "opa is NOT in PATH, please install opa with 'brew install opa'" 1>&2; exit 1; }

# Check if Jinja2 is installed
[[ $(type -P "jinja2") ]]  ||
    { echo "jinja2 is NOT in PATH, please install jinja2-cli with 'pip3 install jinja2-cli'" 1>&2; exit 1; }

# Get policies metadata for template processing
OPA_INSPECT_JSON=$(opa inspect -a -f json policies)
echo $OPA_INSPECT_JSON > TEMP_policies.json

# Process POLICIES.md template with policy metadata
jinja2 docs/templates/POLICIES.md.j2 TEMP_policies.json -o docs/POLICIES.md

# Ensure POLICIES.md file is added to current commit
git add docs/POLICIES.md

# Clean up
rm TEMP_policies.json
exit 0