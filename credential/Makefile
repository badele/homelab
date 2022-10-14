MAKEFLAGS += --no-print-directory

.POSIX:
.PHONY: *

get-argocd: ## Get argocd credential
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

get-vault: ## Get vault credential
	@kubectl -n vault get secret vault-unseal -o jsonpath="{.data.root-token}" | base64 -d
