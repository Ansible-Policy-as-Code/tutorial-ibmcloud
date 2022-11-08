package corp.policies

########################
# Parameters for Policy
########################

# Consider only these resource types in policy evaluations
all_resource_types := {
    "ibm_cloudant",
    "ibm_cos_bucket"
}

#########
# Policy
#########

# Input passes validation if there are no policy violations for input
# with level = 'BLOCK'
default passes_validation := false
passes_validation {
    num_blocks := count( [ v | v := policy_violations[_]; v.level == LEVEL.BLOCK ] )
    num_blocks == 0
}

# -----------------------------------------------------------------------------
# Policy:       CORP-040-00001
# Description:  All ibm_cloudant resources must contain a tag matching
#               costcenter:NNNNNN where N is some number 0-9
# -----------------------------------------------------------------------------
CORP_040_00001_id := "CORP-040-00001"
CORP_040_00001_message := "Resource is missing costcenter tag or does not comply to required regex"
CORP_040_00001_playbook := "playbooks/attach_user_tag_to_ic_resource.yaml"
# standardize_terraform(tf_resource) = std_resource {
#     std_resource := {
#         "id": tf_resource.address,
#         "type": tf_resource.type,
#         "values": tf_resource.change.after
#     }
# }
CORP_040_00001_playbook_variables(cloudant_resource) := playbook_vars {
    playbook_vars := {
            "resource_id": cloudant_resource.id,
            "tag_names": ["costcenter:000000"]
    }
}
# add CORP_040_00001 policy to policy set
policies[policy_id] := policy {
    policy_id := CORP_040_00001_id
    policy := {
        "reason": CORP_040_00001_message,
        "level": LEVEL.BLOCK,
        "playbook": CORP_040_00001_playbook
    }
}

# add CORP_040_00001 violations to violations list if any exist
policy_violations[CORP_040_00001_violation] {

    # select all resources that require a costcenter tag
    resources_requiring_costcenter_tag := array.concat(
        resources["ibm_cloudant"],
        []
    )

    # get a list of resources that comply with the costcenter tag policy
    with_costcenter_tag := { index |
        some index, tag

        # check that some tag matches the required regex for each
        regex.match(
            "^costcenter:(\\d){6}$", 
            resources_requiring_costcenter_tag[index].values.tags[tag]
        )
    }

    # get a list of of non-compliant resources [all resouces minus compliant resources]
    without_costcenter_tag := { index |
        some index
        resources_requiring_costcenter_tag[index]
        not with_costcenter_tag[index]
    }

    # loop through without_costcenter_tag[] and create a new policy violation
    some i
    CORP_040_00001_violation := new_violation(
        CORP_040_00001_id,
        resources_requiring_costcenter_tag[ without_costcenter_tag[i] ],
        CORP_040_00001_playbook_variables(resources_requiring_costcenter_tag[ without_costcenter_tag[i] ])
    )

}

# -----------------------------------------------------------------------------
# Policy:       CORP-040-00002
# Description:  All ibm_cos_buckets must not use public endpoints
# -----------------------------------------------------------------------------
CORP_040_00002_id := "CORP-040-00002"
CORP_040_00002_message := "Cloud Object Storage buckets must not use public endpoints"

# add CORP_040_00002 policy to policy set
policies[policy_id] := policy {
    policy_id := CORP_040_00002_id
    policy := {
        "reason": CORP_040_00002_message,
        "level": LEVEL.BLOCK,
        "playbook": "Not implemented"
    }
}

# add CORP_040_00002 violations to violations list if any exist
policy_violations[CORP_040_00002_violation] {

    # select all Cloud Object Storage buckets
    cloud_object_storage_buckets := resources["ibm_cos_bucket"]

    # get a list of COS buckets that have public endpoints
    some index
    cloud_object_storage_buckets[index].values.endpoint_type == "public"

    # loop through with_public_endpoints[] and create a new policy violation
    CORP_040_00002_violation := new_violation(
        CORP_040_00002_id,
        cloud_object_storage_buckets[index],
        {}
    )

}

####################
# Common Library
####################

# Constants for policy levels
LEVEL := {
    "BLOCK": "BLOCK",
    "WARN": "WARN"
}

# list of all resources of a given type
resources[resource_type] := all {
    some resource_type
    all_resource_types[resource_type]

    # query all resources from input and convert to a standard format
    all := array.concat(
        # Terraform resources
        tf_resources[resource_type],

        # IBM Cloud resources
        ic_resources[resource_type]
    )
}

new_violation(policy_id, resource, playbook_variables) = resource_failure {
  resource_failure := {
    "id": resource.id,
    "policy_id": policy_id,
    "reason": policies[policy_id].reason,
    "level": policies[policy_id].level,
    "playbook": policies[policy_id].playbook,
    "playbook_variables": playbook_variables
  }
}

####################
# Terraform Library
####################

tf_resources[resource_type] := all {
    some resource_type
    all_resource_types[resource_type]

    all := [resource | 
        tf_resource := input.tfplan.resource_changes[_]
        resource := standardize_terraform(tf_resource)
        resource.type == resource_type
    ]
}

standardize_terraform(tf_resource) = std_resource {
    std_resource := {
        "id": tf_resource.address,
        "type": tf_resource.type,
        "values": tf_resource.change.after
    }
}

####################
# IBM Cloud Library
####################

ic_resources[resource_type] := all {
    some resource_type
    all_resource_types[resource_type]

    all := [resource |
        resource := input.ibmcloud.resources[_]
        resource.type == resource_type
    ]
}
