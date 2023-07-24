FROM arthurniedz/cram:devel

FROM yxzhan/intel4coro:jupyterhub-ros-base-0.3

ARG IAI_WS=/home/workspace/ros

USER ${NB_USER}
# Replace ROS workspace
COPY --from=0 --chown=${NB_USER}:users /home/workspace /home/workspace
# === To be deleted after cram branch merged ===
RUN rm -rf /home/workspace/ros/src/cram/cram_common/cram_tf && \
    git clone https://github.com/cram2/cram.git -b devel ${HOME}/cram_devel && \
    mv ${HOME}/cram_devel/cram_common/cram_tf /home/workspace/ros/src/cram/cram_common/cram_tf && \
    rm -rf ${HOME}/cram_devel

RUN mv ${HOME}/workspace/ros/src/rvizweb ${HOME}/workspace/ros/src/rosboard /home/workspace/ros/src/ && \
    rm -rf ${HOME}/workspace && \
    ln -s /home/workspace ${HOME}/workspace
# ===  END ===
WORKDIR ${IAI_WS}
# Install PyKDL from source
RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git src/orocos_kinematics_dynamics -b v1.5.1
RUN cd src/orocos_kinematics_dynamics && git submodule update --init
# Rebuild ROS workspace
USER root
RUN apt-get update && rosdep install -y --ignore-src --from-paths ./ -r
USER ${NB_USER}
RUN catkin build

# Clean cache
RUN npm cache clean --force && pip cache purge && rm -rf ${HOME}/.cache/bower && mamba clean -ya

# Fix 3d Meshes material files missing issue
RUN cd ${HOME}/workspace/ros/src/cram/cram_demos/cram_projection_demos/resource/household && \
    sed -i '3d' bowl.obj cup.obj

# Intall CommonLisp kernel.
RUN /usr/bin/sbcl --load ${IAI_WS}/src/cram/jupyter/sbcl-jupyter-kernel-installer.lisp

# Clone this repository and set it as the working directory
# Overwrite the entrypoint, and it has to end with `exec "$@"`.
# Do not start the juptyerlab server in the entrypoint script, it should be launched by the jupyterhub.
WORKDIR /home/${NB_USER}
COPY --chown=${NB_USER}:users ./ /home/${NB_USER}/repo
RUN chmod +x ${HOME}/repo/binder/init.sh

# Precompile and cache LISP code for demo notebooks
RUN source ${IAI_WS}/devel/setup.bash && xvfb-run /usr/bin/sbcl --load ${HOME}/repo/binder/pre-compile.lisp
RUN jupyter lab workspaces import /home/${NB_USER}/repo/binder/workspace.json

WORKDIR ${HOME}/repo/
ENTRYPOINT ["/home/jovyan/repo/binder/init.sh"]