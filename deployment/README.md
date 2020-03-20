# Deployment

## Cluster setup
- Master zone: europe-west3, Node zones: europe-west3-a, europe-west3-b, and europe-west3-c
- Machine type: n1-standard-1 (1 vCPU; 3.75 GB Memory; boot disk size: 100 GB)
- 3 nodes for ETCD deployment with metadata `nodetype: etcd`
- 3 nodes for MultiChain deployment with metadata `nodetype: multichain`
- 15 nodes for benchmark (tamper-proof broadcast protocols) deployment with metadata `nodetype:tamperproofbroadcast`

## Connect to GKE
```
# https://cloud.google.com/kubernetes-engine/docs/tutorials/authenticating-to-cloud-platform
kubectl create secret generic pubsub-key --from-file=key.json=PATH-TO-KEY-FILE.json
```

## Deploy etcd to kubernetes
```
sh etcd/etcd-deployment.sh
```

## Deploy multichain to kubernetes
```
sh multichain/multichain-deployment.sh
```

## Deploy benchmarks to kubernetes
```
```

## Watch deployment
```
watch -n1 'kubectl get all;'
```
