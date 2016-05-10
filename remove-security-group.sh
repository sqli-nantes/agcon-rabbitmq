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

export rc=0 # return code

echo "suppression du security group"
aws ec2 delete-security-group --group-name ${SG_NAME}
rc=$?

if [[ rc -eq 0 ]]; then
  echo "fin du script OK"
else
  echo "fin du script KO : ERREUR ${rc}"
fi

exit ${rc}
