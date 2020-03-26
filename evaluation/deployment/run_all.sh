SCRIPTPATH=$(dirname "$0")

sh $SCRIPTPATH/benchmarks/generate-benchmarks.sh

for N_REPLICAS in 3 6 9 12
do
  for PROTOCOL in fotb totb htlltb htlltbtest
  do
    TEST=$PROTOCOL-$N_REPLICAS
    DEPLOYMENTYAML=$SCRIPTPATH/benchmarks/tmp/$TEST-benchmark-deployment.yaml
    DEPLOYMENTSCRIPT=$SCRIPTPATH/benchmarks/tmp/$TEST-benchmark-deployment.sh
    DELETEDEPLOYMENTSCRIPT=$SCRIPTPATH/benchmarks/tmp/$TEST-delete-benchmark-deployment.sh
    echo running: $TEST
    sh $SCRIPTPATH/etcd/etcd-deployment.sh
    sleep 180

    sh $SCRIPTPATH/multichain/multichain-deployment.sh
    sleep 60

    sh $DEPLOYMENTSCRIPT
    sleep 420
    sh $SCRIPTPATH/benchmarks/print-logs.sh > $SCRIPTPATH/$TEST.log
    sh $DELETEDEPLOYMENTSCRIPT
    sleep 30

    sh $SCRIPTPATH/multichain/delete-multichain-deployment.sh
    sleep 30
    sh $SCRIPTPATH/etcd/delete-etcd-deployment.sh
    sleep 30
  done
done
