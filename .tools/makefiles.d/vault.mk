vault-credential: ## Get vault credential
	@cd deployment/bootstrap/vault && echo "vault(token) => '$$(./cmd.sh credential)'"

vault-forward: vault-credential ## Vault kubernetes forward
	kubectl port-forward -n vault svc/vault 8200:8200
