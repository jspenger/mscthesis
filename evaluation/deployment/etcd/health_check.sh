# check health
echo check etcd health
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json member list' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint status' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint health' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint hashkv' | jq
