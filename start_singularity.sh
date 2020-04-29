#!/bin/bash
source config.sh
singularity instance start \
	--bind "${CHORD_TEMP_PATH}":/chord/tmp \
	--bind "${CHORD_DATA_PATH}":/chord/data \
	--bind /usr/share/zoneinfo/Etc/UTC:/usr/share/zoneinfo/Etc/UTC \
	${HOME}/chord_singularity/chord.sif \
	chord_hsc
