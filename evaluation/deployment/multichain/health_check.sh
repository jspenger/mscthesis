# check health
echo check multichain health
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getinfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getlastblockinfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getpeerinfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichain-{} -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getblockchaininfo'
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichainetcd-{} -- bash -c 'etcdctl -w=json member list' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichainetcd-{} -- bash -c 'etcdctl -w=json endpoint status' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichainetcd-{} -- bash -c 'etcdctl -w=json endpoint health' | jq
echo {0..5} | tr " " "\n" | xargs -I{} kubectl exec multichainetcd-{} -- bash -c 'etcdctl -w=json endpoint hashkv' | jq
