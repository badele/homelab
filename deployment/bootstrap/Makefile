MAKEFLAGS += --no-print-directory

.POSIX:
.PHONY: *

##############################################################################
# SANDBOX
##############################################################################

argocd: argocd/Chart.yaml 
	kubectl create namespace argocd > /dev/null || true
	cd argocd && helm dependency update
	cd argocd && ./cmd.sh deploy

vault: 
	kubectl create namespace vault > /dev/null || true
	cd vault && helm dependency update
	cd vault && ./cmd.sh deploy

stack:
	cd stack && ./cmd.sh deploy

deploy: argocd vault stack