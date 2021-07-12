PROXY_HUB_DOCKER=1
PROXY_GCR=1
PROXY_K8S_GCR=1

install_k3s() {
  which k3s > /dev/null 2>&1
  if [ $? != 0 ]; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644" sh - > /dev/null 2>&1
    sudo k3s kubectl get node
  fi
}

create_pods() {
  sudo kubectl apply -f pod-base.yaml

  if [ $PROXY_HUB_DOCKER == 1 ]; then
    sudo kubectl apply -f pod-hub-registry.yaml
    cat /etc/hosts | grep " hub-k3s.io" > /dev/null 2>&1 \
      || sudo sed -i "s/\(^127\.0\.0\.1.*$\)/\1      hub-k3s.io/g" /etc/hosts
    echo "hub-k3s.io => "$(curl -si -X GET "hub-k3s.io" | grep "200 OK")
  fi

  if [ $PROXY_GCR == 1 ]; then
    sudo kubectl apply -f pod-gcr-registry.yaml
    cat /etc/hosts | grep " gcr-k3s.io" > /dev/null 2>&1 \
      || sudo sed -i "s/\(^127\.0\.0\.1.*$\)/\1      gcr-k3s.io/g" /etc/hosts
    echo "gcr-k3s.io => "$(curl -si -X GET "gcr-k3s.io" | grep "200 OK")
  fi

  if [ $PROXY_K8S_GCR == 1 ]; then
    sudo kubectl apply -f pod-k8s-gcr-registry.yaml
    cat /etc/hosts | grep " k8s-gcr-k3s.io" > /dev/null 2>&1 \
      || sudo sed -i "s/\(^127\.0\.0\.1.*$\)/\1      k8s-gcr-k3s.io/g" /etc/hosts
    echo "k8s-gcr-k3s.io => "$(curl -si -X GET "k8s-gcr-k3s.io" | grep "200 OK")
  fi
}

install_k3s && create_pods
