# Deployment How-to
This is a short guide on how to deploy and run the experimental evaluation of the tamper-proof broadcast protocols on a kubernetes cluster (on google kubernetes engine).

The results are uploaded to a google cloud storage bucket, for which the correct credentials are needed to be set during the setup (connect to GKE) and .

## Cluster setup
- Master zone: europe-west3, Node zones: europe-west3-a, europe-west3-b, and europe-west3-c
- Machine type: n1-standard-1 (1 vCPU; 3.75 GB Memory; boot disk size: 100 GB)
- 3 nodes for ETCD deployment with metadata `nodetype: etcd`
- 3 nodes for MultiChain deployment with metadata `nodetype: multichain`
- 15 nodes for benchmark (tamper-proof broadcast protocols) deployment with metadata `nodetype:tamperproofbroadcast`

## Connect to GKE
```
# connect to the cluster (replace XXX)
gcloud container clusters get-credentials XXX --zone europe-west3-a --project XXX
# for access to google cloud storage
# https://cloud.google.com/kubernetes-engine/docs/tutorials/authenticating-to-cloud-platform
kubectl create secret generic pubsub-key --from-file=key.json=PATH-TO-KEY-FILE.json
```

## Deploy to kubernetes
```
# deploy etcd and wait for 2 minutes
sh etcd/etcd-deployment.sh
sleep 120
# deploy multichain
sh multichain/multichain-deployment.sh
# deploy the benchmark (chose one of the suitable benchmarks)
sh benchmarks/benchmark-deployment.sh
# watch progress
watch -n1 'kubectl get all;'
```

## Delete kubernetes deployment
```
sh benchmarks/delete-benchmark-deployment.sh
sh multichain/delete-multichain-deployment.sh
sh etcd/delete-etcd-deployment.sh
```
