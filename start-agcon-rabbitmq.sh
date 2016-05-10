#!/bin/bash

# script de demarrage du brocker rabbitmq agence connectee
#
# prerequis :
# - un acces AWS IAM doit etre configure (aws configure)
# - le security group ${SG_NAME} doit etre cree
#
# dépendances :
# - AWS command line (un acces AWS IAM doit etre configure)
# - docker
# - docker-machine
#
# lancer ce script en sudo
# ce script doit etre lance depuis son repertoire uniquement

export AWS_PROJECT=agcon-rabbitmq
export SG_NAME=docksg${AWS_PROJECT}
export DOCKER_INSTANCE=dockinstance${AWS_PROJECT}

export SSH_PORT=22
export BROCKER_PORT=5672

export rc=0 # return code
export aws_id=-1 # identifiant de l'instance

echo "demarrage de "${AWS_PROJECT}

echo "creation de la docker-machine"
docker-machine create --driver amazonec2 \
--amazonec2-region us-east-1 \
--amazonec2-zone c \
--amazonec2-security-group ${SG_NAME} \
--amazonec2-tags project:${AWS_PROJECT} ${DOCKER_INSTANCE}
rc=$?

if [[ rc -eq 0 ]]; then
  echo "Recuperation de l'id de l'instance de machine ec2"
  export aws_id=`aws ec2 describe-instances --filters "Name=tag-value,Values=${DOCKER_INSTANCE}" --output text --query 'Reservations[0].Instances[0].InstanceId'`
  echo "instance id :"${aws_id}
fi

if [[ rc -eq 0 ]]; then
  echo "positionnement des variables d'environnement de la docker-machine ${DOCKER_INSTANCE}"
  eval $(docker-machine env ${DOCKER_INSTANCE})
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "docker-machine ip ${DOCKER_INSTANCE}"
  docker-machine ip ${DOCKER_INSTANCE}
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "docker-machine status ${DOCKER_INSTANCE}"
  docker-machine status ${DOCKER_INSTANCE}
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "build de l'image docker ${AWS_PROJECT}"
  docker build -t ${AWS_PROJECT} .
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "creation et demmarage des containers docker"
  docker-compose up -d
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "fin du script OK"
else
  echo "fin du script KO : ERREUR ${rc}"
fi

exit ${rc}
