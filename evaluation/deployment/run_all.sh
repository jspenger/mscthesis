SCRIPTPATH=$(dirname "$0")

echo start run all

mkdir $SCRIPTPATH/benchmarks/tmp
export N_REPLICAS
export BENCHMARKCOMMAND
export DEPLOYMENTYAML
export DEPLOYMENTSCRIPT
export DELETEDEPLOYMENTSCRIPT
export BLOCKNUMBER

# bootstrap multichain
sh $SCRIPTPATH/multichain/multichain-deployment.sh
sleep 300

for N_REPLICAS in 3 6 9 12
do
  # fotb
  TEST=fotb-$N_REPLICAS
  DEPLOYMENTYAML=fotb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=fotb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=fotb-$N_REPLICAS-delete-benchmark-deployment.sh
  BLOCKNUMBER=$(kubectl exec -it statefulset/multichain -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getinfo' | tail -n +2 | jq '.blocks')
  sleep 30
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=180 --benchmark-testid=fotb-'$N_REPLICAS'-$(hostname) fotb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --fotb-startheight='$BLOCKNUMBER';'
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/benchmarks/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT

  echo running: $TEST
  sh $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  sleep 420
  sh $SCRIPTPATH/benchmarks/print-logs.sh 2>&1 > $SCRIPTPATH/$TEST.log
  sh $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT
  sleep 30

  # totb
  TEST=totb-$N_REPLICAS
  DEPLOYMENTYAML=totb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=totb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=totb-$N_REPLICAS-delete-benchmark-deployment.sh
  BLOCKNUMBER=$(kubectl exec -it statefulset/multichain -- bin/ash -c 'multichain-cli chain --rpcuser=user --rpcpassword=password getinfo' | tail -n +2 | jq '.blocks')
  sleep 30
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=180 --benchmark-testid=totb-'$N_REPLICAS'-$(hostname) totb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --totb-startheight='$BLOCKNUMBER';'
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/benchmarks/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT

  echo running: $TEST
  sh $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  sleep 420
  sh $SCRIPTPATH/benchmarks/print-logs.sh 2>&1 > $SCRIPTPATH/$TEST.log
  sh $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT
  sleep 30

  # htlltb
  TEST=htlltb-$N_REPLICAS
  DEPLOYMENTYAML=htlltb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=htlltb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=htlltb-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=180 --benchmark-testid=htlltb-'$N_REPLICAS'-$(hostname) htlltb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --fotb-startheight=0 --etcd-host=etcd.default.svc.cluster.local --etcd-port=2379;'
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/benchmarks/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT

  echo running: $TEST
  sh $SCRIPTPATH/etcd/etcd-deployment.sh
  sleep 180
  sh $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  sleep 420
  sh $SCRIPTPATH/benchmarks/print-logs.sh 2>&1 > $SCRIPTPATH/$TEST.log
  sh $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT
  sleep 30
  sh $SCRIPTPATH/etcd/delete-etcd-deployment.sh
  sleep 30

  # htlltbtest
  TEST=htlltbtest-$N_REPLICAS
  DEPLOYMENTYAML=htlltbtest-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=htlltbtest-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=htlltbtest-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=180 --benchmark-testid=htlltbtest-'$N_REPLICAS'-$(hostname) htlltbtest --etcd-host=etcd.default.svc.cluster.local --etcd-port=2379;'
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmarks/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/benchmarks/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT

  echo running: $TEST
  sh $SCRIPTPATH/etcd/etcd-deployment.sh
  sleep 180
  sh $SCRIPTPATH/benchmarks/tmp/$DEPLOYMENTSCRIPT
  sleep 420
  sh $SCRIPTPATH/benchmarks/print-logs.sh 2>&1 > $SCRIPTPATH/$TEST.log
  sh $SCRIPTPATH/benchmarks/tmp/$DELETEDEPLOYMENTSCRIPT
  sleep 30
  sh $SCRIPTPATH/etcd/delete-etcd-deployment.sh
  sleep 30

done

sh $SCRIPTPATH/multichain/delete-multichain-deployment.sh
sleep 30

echo finished run all
