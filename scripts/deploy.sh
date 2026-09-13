#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-dev}
ACTION=${2:-plan}

case "$ENVIRONMENT" in dev|staging|prod) ;; *) echo "Environment must be dev, staging, or prod" >&2; exit 1 ;; esac
case "$ACTION" in plan|apply|destroy) ;; *) echo "Action must be plan, apply, or destroy" >&2; exit 1 ;; esac

WORK_DIR="environments/$ENVIRONMENT"
test -f "$WORK_DIR/backend.hcl" || { echo "Copy backend.hcl.example to backend.hcl first" >&2; exit 1; }
test -f "$WORK_DIR/terraform.tfvars" || { echo "Copy terraform.tfvars.example to terraform.tfvars first" >&2; exit 1; }

terraform -chdir="$WORK_DIR" init -backend-config=backend.hcl
terraform -chdir="$WORK_DIR" validate
terraform -chdir="$WORK_DIR" "$ACTION" -var-file=terraform.tfvars

