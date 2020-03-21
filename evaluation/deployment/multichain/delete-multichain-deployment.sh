SCRIPTPATH=$(dirname "$0")

# delete current multichain deployment
kubectl delete --all -f $SCRIPTPATH/multichain-deployment.yaml
