#!/usr/bin/env bash

APPNAME=argocd

# Installa application
kubectl create namespace ${APPNAME} --dry-run=client --output=yaml | kubectl apply -f -
helm template \
    --include-crds \
    --namespace ${APPNAME} \
    ${APPNAME} . \
    | kubectl apply -n ${APPNAME} -f -

# Install curstom resources
kubectl -n ${APPNAME} wait --timeout=60s --for condition=Established \
       crd/applications.argoproj.io \
       crd/applicationsets.argoproj.io
