SCRIPTPATH=$(dirname "$0")

# deploy etcd to kubernetes
helm install multichainetcd bitnami/etcd --set auth.rbac.enabled=false,statefulset.replicaCount=6,nodeSelector.etcdnodetype=etcd,persistence.enabled=false;
sleep 120

# delete multichain key from etcd
kubectl exec statefulset/multichainetcd -- bash -c 'multichainetcd del multichain'
# deploy multichain to kubernetes
kubectl apply -f $SCRIPTPATH/multichain-deployment.yaml
