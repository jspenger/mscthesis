# check multichain health
echo check multichain health
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getlastblockinfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getpeerinfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getblockchaininfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichainetcd-{} -- bin/ash -c 'etcdctl -w=json member list' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichainetcd-{} -- bin/ash -c 'etcdctl -w=json endpoint status' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichainetcd-{} -- bin/ash -c 'etcdctl -w=json endpoint health' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it multichainetcd-{} -- bin/ash -c 'etcdctl -w=json endpoint hashkv' | jq

# check etcd health
echo check etcd health
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json member list' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint status' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint health' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec -it etcd-{} -- bin/ash -c 'etcdctl -w=json endpoint hashkv' | jq
