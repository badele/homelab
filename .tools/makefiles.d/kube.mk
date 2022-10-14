forward-argocd: ## Argocd kubernetes forward
	make credential-argocd
	kubectl port-forward -n argocd svc/argocd-server 8080:80

forward-vault: ## Vault kubernetes forward
	make credential-vault
	kubectl port-forward -n vault svc/vault 8200:8200

forward-tekton: ## tekton kubernetes forward
	make credential-argocd
	kubectl port-forward -n tekton-pipelines svc/tekton-dashboard 8080:9097
