#!/usr/bin/env bash

# https://www.vaultproject.io/docs/platform/k8s/helm/run
# https://github.com/hashicorp/vault-helm/blob/main/test/acceptance/injector-test/bootstrap.sh

APPNAME=vault
NBKEYS=3
VAULTFILENAME="/tmp/vault.unseal"

remove_secret_files() {
    rm -f /tmp/vault.unseal
}
trap "remove_secret_files" EXIT

install_vault() {
    # Allready installed
    if kubectl get namespaces ${APPNAME} > /dev/null; then
        if kubectl -n ${APPNAME} get pod vault-0 > /dev/null; then
            if [[ $(kubectl -n ${APPNAME} get pods vault-0 -o 'jsonpath={..status.containerStatuses[0].started}') -eq "true" ]]; then
                echo "Vault allready installed"
                return
            fi
        fi
    fi

    # Install application
    kubectl create namespace ${APPNAME} --dry-run=client --output=yaml | kubectl apply -f -
    helm template \
        --include-crds \
        --namespace ${APPNAME} \
        ${APPNAME} . \
        | kubectl apply -n ${APPNAME} -f -


    # Wait pod in running state
    while [[ $(kubectl -n ${APPNAME} get pods vault-0 -o 'jsonpath={..status.containerStatuses[0].started}') != "true" ]]; do echo "waiting for vault-O is up" && sleep 1; done
    sleep 5

    # Init vault
    kubectl -n ${APPNAME} exec -ti vault-0 -- sh -c "vault operator init -n ${NBKEYS} -t ${NBKEYS} | grep -oE '[A-Za-z0-9_@./#&+-]{44}|[A-Za-z0-9_@./#&+-]{28}' | tr -d '\r' | tr '\n' ' '" > ${VAULTFILENAME}

    KEYS=$(cat ${VAULTFILENAME})

    # Count nb unseal keys
    onlyreturnline="${KEYS//[! ]/}"
    nblines=${#onlyreturnline}


    # TODO: define keys in variables for hidden on error bash script
    IDX=0
    COMMANDSECRETS="kubectl -n ${APPNAME} create secret generic vault-unseal"

    for key in $KEYS; do
        IDX=$((IDX+1))
        if [ "$IDX" -ne "$nblines" ]; then
            COMMANDSECRETS="${COMMANDSECRETS} --from-literal=unseal-${IDX}='${key}'"
        else
            COMMANDSECRETS="${COMMANDSECRETS} --from-literal=root-token='${key}'"
        fi
    done

    # Store secrets
    bash -c "${COMMANDSECRETS}"
}

unseal_vault() {
    for idx in $(seq ${NBKEYS}); do
        KEY=$(kubectl -n ${APPNAME} get secret vault-unseal -o jsonpath="{.data.unseal-${idx}}" | base64 --decode)
        kubectl -n ${APPNAME} exec -ti vault-0 -- vault operator unseal "${KEY}"
    done
}

install_vault
unseal_vault