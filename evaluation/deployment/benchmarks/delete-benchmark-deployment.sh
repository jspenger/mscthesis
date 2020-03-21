SCRIPTPATH=$(dirname "$0")

# delete all current deployments
kubectl delete --all -f $SCRIPTPATH/benchmark-tamperproofbroadcast-deployment.yaml
