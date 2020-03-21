SCRIPTPATH=$(dirname "$0")

# delete current etcd deployment
helm uninstall etcd
