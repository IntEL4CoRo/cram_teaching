#!/bin/bash

source ${HOME}/workspace/ros/devel/setup.bash

roscore &
roslaunch --wait rvizweb rvizweb.launch config_file:=${HOME}/repo/binder/rviz_config.json &

xvfb-run exec "$@"
# exec "$@"