credential-argocd: ## Get argocd credential
	@echo "Argocd(admin) => '$$(make -C credential get-argocd)'"

credential-vault: ## Get vault credential
	@echo "vault(token) => '$$(make -C credential get-vault)'"
