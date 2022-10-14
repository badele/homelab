admin: ## Homelab environment tools
	@command -v nix-shello > /dev/null && nix-shell --pure || docker run \
		--name homelab-admin \
		--rm \
		--interactive \
		--tty \
		--network host \
		--volume "/var/run/docker.sock:/var/run/docker.sock" \
		--volume $$(pwd):$$(pwd) \
		--volume ${HOME}/.ssh:/root/.ssh \
		--volume ${HOME}/.terraform.d:/root/.terraform.d \
		--volume homelab-tools-cache:/root/.cache \
		--volume homelab-tools-nix:/nix \
		--workdir $$(pwd) \
		nixos/nix nix-shell

sandbox-deploy: ## Create sandbox stack
	@make -C deployment/k3d deploy
	@make -C deployment/bootstrap deploy

sandbox-destroy: ## Destroy sandbox stack
	@make -C deployment/k3d destroy

sandbox: sandbox-destroy sandbox-deploy	