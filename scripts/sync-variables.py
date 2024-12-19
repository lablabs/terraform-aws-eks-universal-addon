#!/usr/bin/env python

import os
import hcl2
import re
from jinja2 import Environment, FileSystemLoader

def terraform_type(value):
    """Remove ${} from Terraform type definitions"""
    # Currently there is a limition in handling Terraform complex types
    #   https://github.com/amplify-education/python-hcl2/issues/179
    #   https://github.com/amplify-education/python-hcl2/issues/172
    if isinstance(value, str):
        return re.sub(r'\${(.*)}', r'\1', value)
    return value

env = Environment(loader=FileSystemLoader("."))
env.filters['terraform_type'] = terraform_type

template = env.from_string("""# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.
{%- for variable in variables %}
{%- for name, spec in variable.items() %}
{%- if name != 'enabled' %}
variable "{{ name }}" {
  type        = {{ spec.type | terraform_type }}
  default     = null
  description = "{{ spec.description }}{% if spec.default is defined and spec.default != None %} Defaults to `{% if spec.default is boolean %}{{ spec.default | string | lower }}{% else %}{{ spec.default }}{% endif %}`.{% endif %}"
}
{%- endif %}
{%- endfor %}
{% endfor %}
""")

for module in os.listdir('.terraform/modules'):
    if not module.startswith('addon') or module.find(".") != -1:
        continue

    with open('.terraform/modules/'+module+'/modules/'+module+'/variables.tf', 'r') as f:
        variables = hcl2.load(f).get('variable')

        with open("variables-"+module+".tf", "w") as f:
            f.write(template.render(variables=variables))
