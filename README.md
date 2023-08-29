# Local Lab Setup Guide

## Installation

### Setting up Microk8s

1. Install Microk8s from the 1.27 stable channel:
```
sudo snap install microk8s --classic --channel=1.27/stable
```
Enable required Microk8s add-ons:


```
microk8s enable ingress
microk8s enable dns
microk8s enable hostpath-storage
microk8s.enable dashboard
```
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

```
 kubectl describe postgresqls.acid.zalan.do  testcluster
Name:         testcluster
Namespace:    default
Labels:       team=acid
Annotations:  <none>
API Version:  acid.zalan.do/v1
Kind:         postgresql
Metadata:
  Creation Timestamp:  2023-08-10T12:09:59Z
  Generation:          1
  Resource Version:    130660
  UID:                 9ae585f8-42c6-4351-8d37-b561bebc20d0
Spec:
  Allowed Source Ranges:  <nil>
  Number Of Instances:    1
  Postgresql:
    Version:  15
  Resources:
    Limits:
      Cpu:     500m
      Memory:  500Mi
    Requests:
      Cpu:     100m
      Memory:  100Mi
  Team Id:     acid
  Volume:
    Size:  10Gi
Status:
  Postgres Cluster Status:  Running
Events:                     <none>
```

## Adding a CUDA-enabled Node to a Local Kubernetes Lab

Prerequisites
A node with an NVIDIA GPU.
Ubuntu operating system.
Steps
1. Install NVIDIA Drivers
Install the ubuntu-drivers-common package:
```
sudo apt install ubuntu-drivers-common
```
Check available drivers for your NVIDIA device:
```
ubuntu-drivers devices
```
Install recommended drivers automatically:
```
sudo ubuntu-drivers autoinstall
```
Reboot your node:
```
sudo reboot
```

2. Verify NVIDIA GPU Status
Check the status of your NVIDIA GPU:
```
nvidia-smi
```
3. Install CUDA Toolkit, enable gpu addon, check deamonset
Install the nvidia-cuda-toolkit:
```
sudo apt install nvidia-cuda-toolkit
microk8s enable gpu
microk8s kubectl get daemonset,pods -n gpu-operator-resources
```

4. Join the Node to the Kubernetes Cluster
On your control plane,  initiate the node addition:
```
microk8s add-node

```
This will display the microk8s join command to be executed on the node you wish to add.
On the node you wish to join, run the displayed microk8s join command:
```
microk8s join <CONTROL_PLANE_IP>:<PORT>/<TOKEN> --worker
```
Note: The --worker flag ensures the node joins as a worker, without running the control plane components.

check if it worked
```
 kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t
Node     Available(GPUs)  Used(GPUs)
bastion  1                0
cuda1    1                0
```

Conclusion
By following the steps above, you should have successfully added a CUDA-enabled node to your local Kubernetes lab. You can now deploy GPU-enabled workloads to leverage the computational power of your NVIDIA GPU.

#############
Set up the insecure registry configuration (must be done on both nodes):

```
sudo mkdir -p /var/snap/microk8s/current/args/certs.d/bastion:32000
sudo touch /var/snap/microk8s/current/args/certs.d/bastion:32000/hosts.toml
```
Then, edit the hosts.toml file:

```
sudo vim /var/snap/microk8s/current/args/certs.d/bastion:32000/hosts.toml
```
And add:

```
server = "http://bastion:32000"

[host."http://bastion:32000"]
capabilities = ["pull", "resolve"]
```
Restart MicroK8s on both nodes:

```
microk8s stop
microk8s start
```
############
