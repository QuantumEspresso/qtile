#!/bin/sh
cat /sys/class/drm/card0/device/gpu_busy_percent | tr -d '\n'
echo -n "%"
