#!/bin/bash

ID=$1

SCRIPT_DIR="$( cd ${BASH_SOURCE[0]%/*} ; echo $PWD )"
set -x
sleep 20
./update_status.py $ID

