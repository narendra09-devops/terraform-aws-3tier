#!/usr/bin/env bash
set -euo pipefail

terraform fmt -check -recursive
tflint --init
tflint --recursive
checkov --directory . --config-file .checkov.yml

for environment in dev staging prod; do
  terraform -chdir="environments/$environment" init -backend=false
  terraform -chdir="environments/$environment" validate
done

