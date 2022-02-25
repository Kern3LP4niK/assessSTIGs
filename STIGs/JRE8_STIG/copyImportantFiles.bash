#!/bin/bash
mkdir -p "$checkOutput/../filesystem/"
cp --parents /etc/.java/deployment/deployment.config $checkOutput/../filesystem/

deployment_system_config=$(grep "deployment.system.config=" /etc/.java/deployment/deployment.config | grep -v "^#" | cut -d= -f2)
cp --parents $deployment_system_config $checkOutput/../filesystem/

exception_sites=$(grep "deployment.user.security.exception.sites=" $deployment_system_config | grep -v "^#" | cut -d= -f2)
cp --parents $exception_sites $checkOutput/../filesystem/

