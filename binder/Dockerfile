FROM arthurniedz/cram:devel

FROM intel4coro/intel4coro:jupyterhub-ros-base-0.3

ENV ROS_WS=/home/${NB_USER}/workspace/ros
ENV REPO_NAME=cram_teaching

USER ${NB_USER}
# Replace ROS workspace
COPY --from=0 --chown=${NB_USER}:users /home/workspace/ros/src/* ${ROS_WS}/src/
# === To be deleted after cram branch merged ===
RUN rm -rf ${ROS_WS}/ros/src/cram/cram_common/cram_tf && \
    git clone https://github.com/cram2/cram.git -b devel ${HOME}/cram_devel && \
    mv ${HOME}/cram_devel/cram_common/cram_tf ${ROS_WS}/ros/src/cram/cram_common/cram_tf && \
    rm -rf ${HOME}/cram_devel
# ===  END ===
WORKDIR ${ROS_WS}/src
# Install PyKDL from source
RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git orocos_kinematics_dynamics -b v1.5.1 && \
    cd orocos_kinematics_dynamics && git submodule update --init
RUN wstool update
# Rebuild ROS workspace
USER root
RUN apt-get update && rosdep install -y --ignore-src --from-paths ./ -r
USER ${NB_USER}
RUN catkin build

# Fix 3d Meshes material files missing issue
RUN cd $${ROS_WS}/src/cram/cram_demos/cram_projection_demos/resource/household && \
    sed -i '3d' bowl.obj cup.obj

# Overwrite the entrypoint, and it has to end with `exec "$@"`.
# Do not start the juptyerlab server in the entrypoint script, it should be launched by the jupyterhub.
WORKDIR ${HOME}
COPY --chown=${NB_USER}:users . ${HOME}/${REPO_NAME}
COPY --chown=${NB_USER}:users ./binder ${HOME}/.binder

# Intall CommonLisp kernel.
RUN /usr/bin/sbcl --load ${HOME}/${REPO_NAME}/jupyter/sbcl-jupyter-kernel-installer.lisp

# Precompile and cache LISP code for demo notebooks
RUN source ${ROS_WS}/devel/setup.bash && xvfb-run /usr/bin/sbcl --load ${HOME}/.binder/pre-compile.lisp
RUN jupyter lab workspaces import ${HOME}/.binder/workspace.json

WORKDIR ${HOME}/${REPO_NAME}/
ENTRYPOINT ["/home/jovyan/.binder/entrypoint.sh"]