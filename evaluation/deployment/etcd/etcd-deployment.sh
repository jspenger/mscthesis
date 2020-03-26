SCRIPTPATH=$(dirname "$0")

# deploy etcd to kubernetes
helm install etcd bitnami/etcd --set auth.rbac.enabled=false,statefulset.replicaCount=6,nodeSelector.etcdnodetype=etcd,persistence.enabled=false;
