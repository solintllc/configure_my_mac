#!/usr/bin/env bash

# This script clones a VM named macOS_config_base to a machine named macOS_config_YYYYMMDD_HHMM.
# I use it to quickly clone a VM for testing new Ansible code.
# To build macOS_config_base, see the README.md.

handle_error() {
    echo "An error occurred. Exiting."
    # Additional error handling code here
    exit 1
}

# exit on any error
set -e
trap handle_error ERR

usage() {
   exit_value=0
   if [[ ! -z $1 ]]
   then
      echo "ERROR: $1" >&2
      echo ""
      exit_value=1
   fi

   echo "USAGE: $0 [-h]"
   echo ""
   echo "Clones a VM named macOS_config_base to a machine named macOS_config_YYYYMMDD_HHMM."
   echo -e "\t-h\tThis help message."

   exit ${exit_value}
}

vm_exists() {
   # Returns 0 if the VM exists, 1 otherwise
   local vm_name="${1}"

   exists=1
   prlctl list -a | grep -q "${vm_name}"
   if [[ $? -eq 0 ]]
   then
      exists=0
   fi

   return ${exists}
}

clone_vm(){
   local source_vm_name="${1}"
   local destination_vm_name="${2}"

   # Check that the source VM exists
   vm_exists ${source_vm_name}
   if [[ $? -ne 0 ]]
   then
      usage "Source VM ${source_vm_name} does not exist. See prlctl list -a."
   fi

   # Stop the source VM just in case
   set +e
   prlctl status ${source_vm_name} 2>&1 | grep -q "running"
   if [[ $? -eq 0 ]]
   then
      echo "Shutting down ${source_vm_name}. Check the Parallels UI to see if you need to help it along."
      prlctl stop ${source_vm_name}
   fi
   set -e

   prlctl clone macOS_config_base --name ${destination_vm_name}
   prlctl set ${destination_vm_name} --memsize 8192 --cpus 4 > /dev/null
   prlctl set ${destination_vm_name} --shared-clipboard on > /dev/null
   prlctl start ${destination_vm_name} > /dev/null
}


main() {
   if [[ $# -gt 0 ]]
   then
      usage
   fi

   source_vm_name="macOS_config_base"
   destination_vm_name="macOS_config_$(date +%Y%m%d_%H%M)"
   clone_vm ${source_vm_name} ${destination_vm_name}
}

main "$@"
