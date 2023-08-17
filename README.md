#intall
   sudo snap install microk8s --classic --channel=1.27/stable
   microk8s enable ingress
   microk8s enable dns
   microk8s enable hostpath-storage
   microk8s.enable dashboard


   alias kubectl='microk8s kubectl'
   microk8s stop
   microk8s start
   microk8s status --wait-ready

#local network networking via
   /etc/resolv.conf

#helm
 microk8s.enable helm
 #helm will need EXPORT->kubeconfig 
 sudo snap install helm --classic


#kubectl auth
   cat /var/snap/microk8s/current/credentials/client.config -> ~/.kube/config 

#dashbord login
   kubectl describe secret microk8s-dashboard-token -n kube-system  ingress nginx-ingress

#docker resgistry
   microk8s enable registry
   microk8s kubectl get svc -n container-registry
   docker build -t nginx-https .
   docker tag nginx-https localhost:32000/nginx-https:latest
   docker push localhost:32000/nginx-https:latest
   curl -X GET http://localhost:32000/v2/_catalog


#ArgoCD
  microk8s enable community
  etc

#Postgres operator
 kubectl --namespace=default get pods -l "app.kubernetes.io/name=postgres-operator"
 kubectl --namespace=default get pods -l "app.kubernetes.io/name=postgres-operator-ui"
 kubectl get secret postgres.testcluster.credentials.postgresql.acid.zalan.do -o jsonpath='{.data.password}' | base64 --decode
 kubectl port-forward pod/testcluster-0 5432:5432\n



kubectl get storageclass
 describe storageclass microk8s-hostpath
Name:            microk8s-hostpath
IsDefaultClass:  Yes
Annotations:     kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"},"name":"microk8s-hostpath"},"provisioner":"microk8s.io/hostpath","reclaimPolicy":"Delete","volumeBindingMode":"WaitForFirstConsumer"}
,storageclass.kubernetes.io/is-default-class=true
Provisioner:           microk8s.io/hostpath
Parameters:            <none>
AllowVolumeExpansion:  <unset>
MountOptions:          <none>
ReclaimPolicy:         Delete
VolumeBindingMode:     WaitForFirstConsumer
Events:                <none>



