#install a kubernetes
if ! kubectl get ns default >/dev/null 2>&1; then
    echo "Installing a kubernetes"
    if [[ -v K8S ]]; then
        #k3d
        echo "installing k3d"
        curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
        k3d cluster create k3d-cluster --k3s-arg "--disable=traefik@server:0"
        # kubectl
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin
    else
        #k3s
        echo "installing k3s"
        curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode 644
        sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
        sudo chown $(id -u):$(id -g) ~/.kube/config

    fi
fi

# install helm

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
