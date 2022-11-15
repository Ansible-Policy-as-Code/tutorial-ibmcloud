# Tutorial Appendix

## Documenting Policies using OPA Metadata

OPA provides [annotation-based metadata processing](https://www.openpolicyagent.org/docs/latest/annotations/). This can be used to easily generate human-readable policy documentation using code.

Included in this repository is a script to generate the docs in [POLICIES.md](POLICIES.md) using [Jinja](https://jinja.palletsprojects.com/en/3.1.x/) template engine (Note: this is the same engine that Ansible uses).

As a pre-requisite you must install OPA & Jinja CLI using the following commands.

```shell
brew install opa
pip3 install jinja2-cli
```

In any of your Rego policies, you may add metadata comments similar to the following that will be processed for the documentation. Note the comments are in `YAML` format in Rego comments.

```yaml
# METADATA
# title: CORP-040-00001 - Cost center tagging
# description: >-
#   All ibm_cloudant resources must contain a tag matching
#   costcenter:NNNNNN where N is some number 0-9
# custom:
#   affected_resources:
#     - ibm_cloudant
```

After you have added comments, from the root directory of this project you may run the following script to update the documentation:

```shell
./scripts/updatePoliciesDocument.sh
```

If you wish to update the Markdown template, that is defined in [/docs/templates/POLICIES.md.j2](/docs/templates/POLICIES.md.j2).
