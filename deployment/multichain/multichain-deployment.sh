SCRIPTPATH=$(dirname "$0")

# delete current multichain deployment
kubectl delete --all -f $SCRIPTPATH/multichain-deployment.yaml
# delete all keys on etcd -- fresh restart
kubectl exec etcd-0 -- bash -c 'etcdctl del "" --from-key=true'
# deploy multichain to kubernetes
kubectl apply -f $SCRIPTPATH/multichain-deployment.yaml
