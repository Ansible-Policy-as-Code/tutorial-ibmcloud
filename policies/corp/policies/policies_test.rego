package corp.policies

import future.keywords

test_CORP_040_00001_when_costcenter_matches_regex_passes_tf if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cloudant.cloudant","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:001511"]}}}]}}
    passes_validation with input as test_input
}

test_CORP_040_00001_when_costcenter_matches_regex_passes_ic if {
    test_input := {"ibmcloud":{"resources": [{"id":"crn:xxx","type":"ibm_cloudant","values":{"tags":["costcenter:001511"]}}]}}
    passes_validation with input as test_input
}

test_CORP_040_00001_when_costcenter_mismatches_regex_not_passes_tf if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cloudant.cloudant","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011"]}}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 1 with input as test_input
}

test_CORP_040_00001_when_costcenter_mismatches_regex_not_passes_ic if {
    test_input := {"ibmcloud":{"resources": [{"id":"crn:xxx","type":"ibm_cloudant","values":{"tags":["costcenter:011"]}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 1 with input as test_input
}

test_CORP_040_00001_when_costcenter_mismatches_regex_not_passes if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cloudant.cloudant","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011"]}}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 1 with input as test_input
}

test_CORP_040_00001_when_tags_missing_not_passes if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cloudant.cloudant","type":"ibm_cloudant","change":{"after":{"tags":[]}}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 1 with input as test_input
}

test_CORP_040_00001_detects_multiple if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cloudant.cloudant_1","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011"]}}},{"address":"ibm_cloudant.cloudant_2","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011"]}}},{"address":"ibm_cloudant.cloudant_3","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011111"]}}},{"address":"ibm_cloudant.cloudant_4","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011111"]}}},{"address":"ibm_cloudant.cloudant_5","type":"ibm_cloudant","change":{"after":{"tags":["costcenter:011"]}}},{"address":"ibm_cloudant.cloudant_6","type":"ibm_cloudant","change":{"after":{"tags":[]}}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 4 with input as test_input
    some w, x, y, z
    policy_violations[w].id == "ibm_cloudant.cloudant_1" with input as test_input
    policy_violations[x].id == "ibm_cloudant.cloudant_2" with input as test_input
    policy_violations[y].id == "ibm_cloudant.cloudant_5" with input as test_input
    policy_violations[z].id == "ibm_cloudant.cloudant_6" with input as test_input
}

test_CORP_040_00002_not_allow_public_endpoints if {
    test_input := {"tfplan":{"resource_changes":[{"address":"ibm_cos_bucket.policy_as_code_bucket","type":"ibm_cos_bucket","change":{"after":{"endpoint_type":"public"}}}]}}
    not passes_validation with input as test_input
    count(policy_violations) == 1 with input as test_input
}
