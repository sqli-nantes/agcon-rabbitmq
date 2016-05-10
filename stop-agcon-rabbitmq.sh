#!/bin/bash

# script de d'arret du brocker rabbitmq agence connectee
#
# dépendances :
# - AWS command line (un acces AWS IAM doit etre configure )
# - docker
# - docker-machine
#
# lancer ce script en sudo
# ce script doit etre lance depuis son repertoire uniquement

export AWS_PROJECT=agcon-rabbitmq
export DOCKER_INSTANCE=dockinstance${AWS_PROJECT}
export rc=0 # return code

echo "arret de "${AWS_PROJECT}

echo "suppression de l'instance docker ${DOCKER_INSTANCE}"
docker-machine rm ${DOCKER_INSTANCE}
rc=$?

if [[ rc -eq 0 ]]; then
  echo "fin du script OK"
else
  echo "fin du script KO : ERREUR ${rc}"
fi

exit ${rc}
