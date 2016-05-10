#!/bin/bash

# script de d'arret du brocker rabbitmq agence connectee
#
# dépendances :
# - AWS command line (un acces AWS IAM doit etre configure )
# - docker
# - docker-machine
#
# lancer ce script en sudo
# ce script doit etre lance depuis son repertoire uniquemenent

export AWS_PROJECT=agcon-rabbitmq
export SG_NAME=docksg${AWS_PROJECT}
export SSH_PORT=22
export BROCKER_PORT=5672
export rc=0 # return code


echo "creation du security group aws ec2 "${AWS_PROJECT}

echo "creation du security group ec2"
aws ec2 create-security-group --group-name ${SG_NAME} --description dock-security-group-${AWS_PROJECT}
rc=$?

if [[ rc -eq 0 ]]; then
  echo "ouverture du port ${SSH_PORT} pour ssh"
  aws ec2 authorize-security-group-ingress --group-name ${SG_NAME} --protocol tcp --port ${SSH_PORT} --cidr 0.0.0.0/0
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "ouverture du port ${BROCKER_PORT} du brocker"
  aws ec2 authorize-security-group-ingress --group-name ${SG_NAME} --protocol tcp --port ${BROCKER_PORT} --cidr 0.0.0.0/0
  rc=$?
fi

if [[ rc -eq 0 ]]; then
  echo "fin du script OK"
else
  echo "fin du script KO : ERREUR ${rc}"
fi

exit ${rc}
