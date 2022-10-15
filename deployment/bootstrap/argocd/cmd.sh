#!/usr/bin/env bash

APPNAME=argocd

deploy() {
    # Installa application
    helm template \
        --include-crds \
        --namespace ${APPNAME} \
        ${APPNAME} . \
        | kubectl apply -n ${APPNAME} -f -

    # Install curstom resources
    kubectl -n ${APPNAME} wait --timeout=60s --for condition=Established \
        crd/applications.argoproj.io \
        crd/applicationsets.argoproj.io
}

credential() {
    echo $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
}

login() {
    #kubectl -n ${APPNAME} exec -ti argocd-application-controller-0 -- argocd --insecure login --username admin --password "$(credential)" argocd-server.argocd
    kubectl -n ${APPNAME} exec -ti argocd-application-controller-0 -- argocd login cd.argoproj.io --core
}

app.list() {
    kubectl -n ${APPNAME} exec -ti argocd-application-controller-0 -- argocd app list
}

app.info() {
    kubectl -n ${APPNAME} exec -ti argocd-application-controller-0 -- argocd app get $@
}

$@