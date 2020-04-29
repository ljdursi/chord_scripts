#!/bin/bash
source config.sh
singularity exec instance://${SITEID} bash /chord/container_scripts/stop_script.bash
singularity instance stop ${SITEID}
