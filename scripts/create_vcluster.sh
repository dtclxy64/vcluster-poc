#!/bin/bash

# Usage: ./create_vcluster.sh --plugin_mode <mode> --vcluster_namespace <namespace> --vcluster_name <name>

# Parse named arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --plugin_mode)
      PLUGIN_MODE="$2"
      shift
      shift
      ;;
    --vcluster_namespace)
      VCLUSTER_NAMESPACE="$2"
      shift
      shift
      ;;
    --vcluster_name)
      VCLUSTER_NAME="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Check required arguments
if [[ -z "$PLUGIN_MODE" || -z "$VCLUSTER_NAMESPACE" || -z "$VCLUSTER_NAME" ]]; then
  echo "Missing required arguments."
  echo "Usage: ./create_vcluster.sh --plugin_mode <mode> --vcluster_namespace <namespace> --vcluster_name <name>"
  exit 1
fi

# Try to create namespace (fail if it already exists)
kubectl create namespace "$VCLUSTER_NAMESPACE"

# Install vcluster with Helm
helm upgrade --install "$VCLUSTER_NAME" vcluster \
  --values "values/${PLUGIN_MODE}-values.yaml" \
  --repo https://charts.loft.sh \
  --namespace "$VCLUSTER_NAMESPACE"
