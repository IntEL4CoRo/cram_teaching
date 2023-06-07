#!/bin/bash

source ${HOME}/workspace/ros/devel/setup.bash

# Kill the environment rosnodes
nodes=$(rosnode list)
# Nodes to exclude from killing
exclude=("rosbridge_websocket" "roswww" "rosapi" "rosout")
# exclude=("rosbridge_websocket" "tf2_web_republisher" "roswww" "rosapi" "rosout")

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

# Launch new rosnodes
REPO_CONFIG_PATH=${HOME}/repo/binder
roslaunch ${REPO_CONFIG_PATH}/update_scene.launch  \
          launch_file:=${@} \
          config_path:=${REPO_CONFIG_PATH} &
          

# exec "$@"