SCRIPTPATH=$(dirname "$0")

# delete multichain key from etcd
kubectl exec etcd-0 -- bash -c 'etcdctl del multichain'
# deploy multichain to kubernetes
kubectl apply -f $SCRIPTPATH/multichain-deployment.yaml
