#!/usr/bin/env bash

#Dont run this unless you understand it.
#I accept no responsibility for damage done by this script

branch=alex/amd-staging-drm-next
delta=(include/uapi/drm/drm_fourcc.h include/uapi/drm/drm_mode.h drivers/dma-buf/reservation.c include/linux/reservation.h drivers/gpu/drm include/drm include/uapi/drm/amdgpu_drm.h)
affect_change=false

echo "Operating in: $PWD"
for i in ${delta[*]}; do
  if $affect_change; then
    rm -rf $i
    git checkout $branch -- $i
    git add $i
  else
    echo "Would be removing, checking out and then adding: $i"
  fi
done
