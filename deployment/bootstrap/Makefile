MAKEFLAGS += --no-print-directory

.POSIX:
.PHONY: *

##############################################################################
# SANDBOX
##############################################################################

argocd: argocd/Chart.yaml ## Install argocd
	kubectl create namespace argocd --dry-run=client --output=yaml | kubectl apply -f -
	cd argocd && helm dependency update
	cd argocd && ./apply.sh

vault: 
	cd vault && helm dependency update
	cd vault && ./apply.sh

stack:
	cd stack && ./apply.sh

deploy: argocd vault