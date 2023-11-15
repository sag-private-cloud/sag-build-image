#!/bin/bash

set -e

_check_dockerfile() {
  dockerfileLocation=$1

  # ERRORS
  baseRuntimeArgLine=$(_get_dockerfile_arg_line $dockerfileLocation "baseruntime")
  _fail_on_empty "$baseRuntimeArgLine" "Dockerfile check FAILED. The dockerfile does not declare \"baseruntime\" argument (Example: ARG baseruntime=...)."
  
  baseRuntimeArgLineUsageLine=$(_get_dockerfile_from_line $dockerfileLocation '${baseruntime}')
  _fail_on_empty "$baseRuntimeArgLineUsageLine" "Dockerfile check FAILED. The dockerfile does not use the \"baseruntime\" argument in a FROM instructuon. "

  # WARNINGS
  # TODO consider checking if packages arg is provided and if so fail instead of warn
  wmpRegistryServerArgLine=$(_get_dockerfile_arg_line $dockerfileLocation "wpmregistryserver")
  _warn_on_empty "$wmpRegistryServerArgLine" "Dockerfile check WARNING. The dockerfile does not declare \"wpmregistryserver\" argument (Example: ARG wpmregistryserver=...)."
  
  wmpRegistryArgLine=$(_get_dockerfile_arg_line $dockerfileLocation "wpmregistry")
  _warn_on_empty "$wmpRegistryArgLine" "Dockerfile check WARNING. The dockerfile does not declare \"wpmregistry\" argument (Example: ARG wpmregistry=...)."
  
  wmpRegistryTokenArgLine=$(_get_dockerfile_arg_line $dockerfileLocation "wpmregistrytoken")
  _warn_on_empty "$wmpRegistryTokenArgLine" "Dockerfile check WARNING. The dockerfile does not declare \"wpmregistrytoken\" argument (Example: ARG wpmregistrytoken=...)."
  packagesArgLine=$(_get_dockerfile_arg_line $dockerfileLocation "packages")
  _warn_on_empty "$packagesArgLine" "Dockerfile check WARNING. The dockerfile does not declare \"packages\" argument (Example: ARG packages=...)."
}


# Function that will return non-comment ARG line from docker file or empty string:
#
# Example Docker file:
#   ARG baseruntime=${ubi8}
#
# _get_dockerfile_arg_line $docker_file_location "baseruntime"
# returns: "ARG baseruntime=${ubi8}"
_get_dockerfile_arg_line() {
  dockerfileLocation=$1
  dockerfileArgument=$2
  echo $(_get_dockerfile_line $dockerfileLocation 'ARG '$dockerfileArgument'=')
}

# Function that will return non-comment line from docker file or empty string:
_get_dockerfile_line() {
  dockerfileLocation=$1
  searchedLine=$2
  dockerArgumentLine=`cat $dockerfileLocation | grep -- "$searchedLine" || true`
  echo $(_get_non_commented_docker_line "$dockerArgumentLine")
}

# Function that will return non-comment FORM line from docker file or empty string:
#
# Example Docker file:
#   FROM ${baseruntime} as runtime
#
# _get_dockerfile_form_line $docker_file_location '${baseruntime}'
# returns: "FROM ${baseruntime} as runtime"
_get_dockerfile_from_line() {
  dockerfileLocation=$1
  dockerfileFromSource=$2
  echo $(_get_dockerfile_line $dockerfileLocation 'FROM '$dockerfileFromSource)
}


_get_non_commented_docker_line() {
  line="$1"
  echo "$line" | grep '^[^#]' || true
}

_fail_on_empty() {
  value=$1
  failMsg=$2
  if [ -z "$value" ]
  then
     _fail_with_msg "$failMsg"
  fi
}

_warn_on_empty() {
  value=$1
  warnMsg=$2
  if [ -z "$value" ]
  then
     echo "WARNING: $warnMsg"
  fi
}

_fail_with_msg() {
  failMsg=$1
  echo "ERROR: $failMsg"
  exit 1
}

main()
{
  _check_dockerfile $1
}

main "$@"
