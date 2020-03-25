SCRIPTPATH=$(dirname "$0")

mkdir $SCRIPTPATH/tmp

export N_REPLICAS
export BENCHMARKCOMMAND
export DEPLOYMENTYAML
export DEPLOYMENTSCRIPT
export DELETEDEPLOYMENTSCRIPT

echo generating benchmarks

# number of replicas
for N_REPLICAS in 3 6 9 12
do
  # fotb
  DEPLOYMENTYAML=fotb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=fotb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=fotb-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=300 --benchmark-testid=fotb-'$N_REPLICAS'-$(hostname) fotb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --fotb-startheight=0;'
  cat $SCRIPTPATH/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DELETEDEPLOYMENTSCRIPT

  # totb
  DEPLOYMENTYAML=totb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=totb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=totb-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=300 --benchmark-testid=totb-'$N_REPLICAS'-$(hostname) totb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --totb-startheight=0;'
  cat $SCRIPTPATH/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DELETEDEPLOYMENTSCRIPT

  # htlltb
  DEPLOYMENTYAML=htlltb-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=htlltb-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=htlltb-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=60 --benchmark-testid=htlltb-'$N_REPLICAS'-$(hostname) htlltb --multichain-host=$MULTICHAINHOST --multichain-port=7208 --multichain-chainname=chain@$MULTICHAINHOST --fotb-startheight=0 --etcd-host=etcd.default.svc.cluster.local --etcd-port=2379;'
  cat $SCRIPTPATH/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DELETEDEPLOYMENTSCRIPT

  # htlltbtest
  DEPLOYMENTYAML=htlltbtest-$N_REPLICAS-benchmark-deployment.yaml
  DEPLOYMENTSCRIPT=htlltbtest-$N_REPLICAS-benchmark-deployment.sh
  DELETEDEPLOYMENTSCRIPT=htlltbtest-$N_REPLICAS-delete-benchmark-deployment.sh
  BENCHMARKCOMMAND='MULTICHAINHOST=$(getent hosts multichain-headless | cut -d" " -f1); python3 tamperproofbroadcast/tests/benchmarks/benchmark.py --benchmark-bucketname=tpbexperiment --benchmark-duration=60 --benchmark-testid=htlltbtest-'$N_REPLICAS'-$(hostname) htlltbtest --etcd-host=etcd.default.svc.cluster.local --etcd-port=2379;'
  cat $SCRIPTPATH/benchmark-deployment.yaml.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTYAML
  cat $SCRIPTPATH/benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DEPLOYMENTSCRIPT
  cat $SCRIPTPATH/delete-benchmark-deployment.sh.tmpl | envsubst > $SCRIPTPATH/tmp/$DELETEDEPLOYMENTSCRIPT
done

echo finished generating benchmarks
