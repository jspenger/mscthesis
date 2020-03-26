# Deployment How-to
This is a short guide on how to deploy and run the experimental evaluation of the tamper-proof broadcast protocols on a kubernetes cluster (on google kubernetes engine).

The results are uploaded to a google cloud storage bucket, for which the correct credentials are needed to be set during the setup (connect to GKE) and .

## Cluster setup
- Master zone: europe-west3, Node zones: europe-west3-a, europe-west3-b, and europe-west3-c
- Machine type: n1-standard-2 (2 vCPU; 7.5 GB Memory; boot disk size: 100 GB, Network egress bandwidth 10 Gbps)
- 6 nodes for ETCD deployment with metadata etcdnodetype: etcd`
- 6 nodes for MultiChain deployment with metadata multichainnodetype: multichain`
- 15 nodes for benchmark (tamper-proof broadcast protocols) deployment with metadata broadcastnodetype: broadcast`

## Connect to GKE
```
# connect to the cluster (replace XXX and YYY)
gcloud container clusters get-credentials XXX --zone europe-west3-a --project YYY
# for access to google cloud storage
# https://cloud.google.com/kubernetes-engine/docs/tutorials/authenticating-to-cloud-platform
kubectl create secret generic pubsub-key --from-file=key.json=PATH-TO-KEY-FILE.json
```

Or, start a local kubernetes cluster and label the nodes appropriatly:
```
kubectl label nodes docker-desktop etcdnodetype=etcd
kubectl label nodes docker-desktop multichainnodetype=multichain
kubectl label nodes docker-desktop broadcastnodetype=broadcast
```

## Script to run all benchmarks
```
sh run_all.sh 2>&1 | tee run.log
```

## Deploy to kubernetes
Deploy ETCD:
```
sh etcd/etcd-deployment.sh
```

Deploy MultiChain:
```
sh multichain/multichain-deployment.sh
```

Generate all benchmarks:
```
sh benchmarks/generate-benchmarks.sh;
```

Deploy one of the benchmarks and watch progress:
```
sh benchmarks/tmp/fotb-3-benchmark-deployment.sh
```

Watch progress:
```
watch 'kubectl get all;'
watch 'kubectl logs --tail=10 broadcast-XXX;'
watch kubectl logs --tail=10 jobs/broadcast;
```

Save all logs to file:
```
sh benchmark/print-logs.sh > YYY.log
```

## Delete kubernetes deployment
```
sh benchmarks/tmp/fotb-3-delete-benchmark-deployment.sh
sh multichain/delete-multichain-deployment.sh
sh etcd/delete-etcd-deployment.sh
```

## Download data (either from pods or from GKE)
```

```

## Other remarks
Generate all benchmarks:
```
sh benchmarks/generate-benchmarks.sh;
```

Delete, generate and run benchmark:
```
sh benchmarks/tmp/fotb-3-delete-benchmark-deployment.sh  ; sh benchmarks/generate-benchmarks.sh; sh benchmarks/tmp/fotb-3-benchmark-deployment.sh;
```

Run interactive pod:
```
kubectl run podname -i --rm  --tty --image=jonasspenger/tamperproofbroadcast
```

Execute a command on a running pod (for example on multichain pod):
```
kubectl exec -it multichain-0 -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getinfo'
```
