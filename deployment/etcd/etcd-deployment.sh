SCRIPTPATH=$(dirname "$0")

# delete current etcd deployment
helm uninstall etcd
# deploy etcd to kubernetes
helm install etcd bitnami/etcd --set auth.rbac.enabled=false,statefulset.replicaCount=3,nodeSelector.nodetype=etcd,persistence.enabled=false
