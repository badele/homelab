CREDENTIAL=../../.credentials/kubeconfig.yaml

check-requirements:
	@command -v k3d > /dev/null || (echo "Please install k3d package" ; exit 1)

deploy: check-requirements
	@k3d cluster list homelab-dev > /dev/null 2>&1 || k3d cluster create --config k3d-dev.yaml
	@k3d kubeconfig get homelab-dev > ${CREDENTIAL}
	@chmod 600 ${CREDENTIAL}

destroy: check-requirements
	@k3d cluster list homelab-dev > /dev/null 2>&1 && k3d cluster delete homelab-dev || true
	rm -f ${CREDENTIAL}