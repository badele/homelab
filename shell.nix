# https://status.nixos.org
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a62844b302507c7531ad68a86cb7aa54704c9cb4.tar.gz") {} }:

let
  python-packages = pkgs.python3.withPackages (p: with p; [
    jinja2
    kubernetes
    netaddr
    rich
  ]);

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    ansible
    ansible-lint
    bmake
    curl
    diffutils
    docker
    docker-compose_1 # TODO upgrade to version 2
    git
    go
    gotestsum
    iproute2
    k9s
    kube3d
    kubectl
    kubernetes-helm
    kustomize
    libisoburn
    openssh
    p7zip
    pre-commit
    shellcheck
    stern
    unixtools.column
    terraform
    yamllint

    python-packages
  ];
  shellHook = ''
    export KUBECONFIG=$(pwd)/.credentials/kubeconfig.yaml
    export KUBE_CONFIG_PATH=$KUBECONFIG
  '';    
}
