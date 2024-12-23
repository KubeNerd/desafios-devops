APP=desafio-devops
NAMESPACE=devops

kube-dev:
	@kind create cluster --config kubernetes/kind/cluster.yaml
	@kubectl create ns ${NAMESPACE}
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

kube-deploy:
	@docker build -t $(APP):kind-v1 .
	@kind load docker-image $(APP):kind-v1
	@kubectl apply -f kubernetes/manifests* -n  ${NAMESPACE}

teardown-dev:
	@kind delete clusters kind