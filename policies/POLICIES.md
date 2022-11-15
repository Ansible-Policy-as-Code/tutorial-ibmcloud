# Corp Policies

## Policy Contents

- [CORP-040-00001 - Cost center tagging](#corp-040-00001---cost-center-tagging)
- [CORP-040-00002 - Publicly exposed object storage buckets](#corp-040-00002---publicly-exposed-object-storage-buckets)

## CORP-040-00001 - Cost center tagging

|     |     |
| --- | --- |
| **Description** | All ibm_cloudant resources must contain a tag matching costcenter:NNNNNN where N is some number 0-9 |
| **Location** | [/policies/corp/policies/policies.rego:33](/policies/corp/policies/policies.rego#L33) |
| **Resources Affected** | ibm_cloudant |

## CORP-040-00002 - Publicly exposed object storage buckets

|     |     |
| --- | --- |
| **Description** | No ibm_cos_buckets may use public endpoints |
| **Location** | [/policies/corp/policies/policies.rego:97](/policies/corp/policies/policies.rego#L97) |
| **Resources Affected** | ibm_cos_bucket |
