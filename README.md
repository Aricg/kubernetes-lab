# Local Lab Setup Guide

## Installation

### Setting up Microk8s

1. Install Microk8s from the 1.27 stable channel:
```
sudo snap install microk8s --classic --channel=1.27/stable
Enable required Microk8s add-ons:
```


```
microk8s enable ingress
microk8s enable dns
microk8s enable hostpath-storage
microk8s.enable dashboard
Setup kubectl alias and manage Microk8s status:


```
alias kubectl='microk8s kubectl'
microk8s stop
microk8s start
microk8s status --wait-ready
Local Network Configuration
Update the local network settings via /etc/resolv.conf.
```

Helm Setup
Enable Helm in Microk8s:


```
microk8s.enable helm
```
Install Helm:


```
sudo snap install helm --classic
```
Deploy using Helm:


```
helm install 1.0 example-chart
```
Kubernetes Authentication
To configure kubectl to use the Microk8s context:


```
cat /var/snap/microk8s/current/credentials/client.config > ~/.kube/config
```
Accessing the Kubernetes Dashboard
Retrieve the dashboard token to log in:


```
kubectl describe secret microk8s-dashboard-token -n kube-system
```
Setting Up a Local Docker Registry
Enable the registry:


```
microk8s enable registry
```
View the registry service details:


```
microk8s kubectl get svc -n container-registry
```
Build, tag, and push an image to the registry:


```
docker build -t nginx-https .
docker tag nginx-https localhost:32000/nginx-https:latest
docker push localhost:32000/nginx-https:latest
```
Confirm the image was pushed:


```
curl -X GET http://localhost:32000/v2/_catalog
```
Deploying ArgoCD
Enable the ArgoCD community:


```
microk8s enable community
```
... [Add any additional steps or configurations for ArgoCD]

Setting Up Postgres Operator
Add the Helm repository for the Postgres operator UI:


```
helm repo add postgres-operator-ui-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui
```
Install the Postgres operator UI using Helm:


```
helm install postgres-operator-ui postgres-operator-ui-charts/postgres-operator-ui
```
Check the status of the Postgres operator:


```
kubectl --namespace=default get pods -l "app.kubernetes.io/name=postgres-operator"
```
Access the Postgres operator UI:


```
kubectl port-forward svc/postgres-operator-ui 8081:80
```
Apply the Postgres manifest:


```
kubectl apply -f postgres/testcluster.yaml
```
Retrieve the Postgres password:


```
kubectl get secret postgres.testcluster.credentials.postgresql.acid.zalan.do -o jsonpath='{.data.password}' | base64 --decode
```
Forward a local port to the Postgres pod:


```
kubectl port-forward pod/testcluster-0 5432:5432
```
