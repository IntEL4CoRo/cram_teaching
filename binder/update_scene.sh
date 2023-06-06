#!/bin/bash

source ${HOME}/workspace/ros/devel/setup.bash

REPO_CONFIG_PATH=${HOME}/repo/binder

# roslaunch cram_projection_demos apartment_tiago.launch
# roslaunch cram_projection_demos apartment_pr2.launch
# roslaunch cram_projection_demos household_tiago.launch
# roslaunch cram_projection_demos household_pr2.launch
# roslaunch cram_projection_demos household_donbot.launch
# # roslaunch cram_pr2_popcorn_demo sandbox.launch
# roslaunch cram_projection_demos retail_donbot.launch
roslaunch cram_projection_demos $@ &
# roslaunch ${REPO_CONFIG_PATH}/init_robot_pose.launch msg_file:=${HOME}/repo/binder/$@.txt &
roslaunch rvizweb update_config.launch config_file:=${REPO_CONFIG_PATH}/rviz_config/rviz_config.json

# exec "$@"
