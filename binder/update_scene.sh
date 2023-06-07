#!/bin/bash

source ${HOME}/workspace/ros/devel/setup.bash


# Kill the environment rosnodes
nodes=$(rosnode list)
# Nodes to exclude from killing
exclude=("rosbridge_websocket" "tf2_web_republisher" "roswww" "rosapi" "rosout")

# Loop through the nodes and kill the ones not in the exclusion list
for node in $nodes; do
  # Extract the node name
  node_name=${node##*/}

  # Check if the node should be excluded
  if [[ ! " ${exclude[@]} " =~ " ${node_name} " ]]; then
    # Kill the node
    rosnode kill $node_name
  fi
done

REPO_CONFIG_PATH=${HOME}/repo/binder

# roslaunch cram_projection_demos apartment_tiago.launch
# roslaunch cram_projection_demos apartment_pr2.launch
# roslaunch cram_projection_demos household_tiago.launch
# roslaunch cram_projection_demos household_pr2.launch
# roslaunch cram_projection_demos household_donbot.launch
# # roslaunch cram_pr2_popcorn_demo sandbox.launch
# roslaunch cram_projection_demos retail_donbot.launch
# roslaunch cram_projection_demos retail_pr2.launch

roslaunch --wait cram_projection_demos ${@} &
sleep 1
roslaunch --wait rvizweb update_config.launch config_file:=${REPO_CONFIG_PATH}/rviz_config/${@}.json

roslaunch --wait ${REPO_CONFIG_PATH}/init_robot_pose.launch msg_file:=${HOME}/repo/binder/rviz_config/${@}.txt
# exec "$@"