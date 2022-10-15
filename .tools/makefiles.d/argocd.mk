# Check defined provided
check-appname:
ifndef APPNAME
	$(error APPNAME is undefined)
endif

argocd-credential: ## Get argocd credential
	@cd deployment/bootstrap/argocd && echo "Argocd(admin) => '$$(./cmd.sh credential)'"

argocd-forward: argocd-credential ## Argocd kubernetes forward
	kubectl port-forward -n argocd svc/argocd-server 8080:80

argocd-login: ## Login into
	cd deployment/bootstrap/argocd && ./cmd.sh login

argocd-applist: ## List argocd applications
	cd deployment/bootstrap/argocd && ./cmd.sh app.list

argocd-appinfo: check-appname ## Get argocd application information
	cd deployment/bootstrap/argocd && ./cmd.sh app.info ${APPNAME}
