FROM arthurniedz/cram:test

FROM yxzhan/intel4coro:jupyterhub-0.1.7

ARG IAI_WS=/home/workspace/ros
ARG INIT_DIR=/home/${NB_USER}/work

USER ${NB_USER}
# Replace ROS workspace
COPY --from=0 --chown=${NB_USER}:users /home/workspace /home/workspace
# === To be deleted after cram branch merged ===
RUN rm -rf /home/workspace/ros/src/cram/cram_common/cram_tf
RUN mv ${HOME}/workspace/ros/src/cram/cram_common/cram_tf /home/workspace/ros/src/cram/cram_common/cram_tf
# ===  END ===
RUN rm -rf ${HOME}/workspace
RUN ln -s /home/workspace ${HOME}/workspace
WORKDIR ${IAI_WS}
# Install Rvizweb and PyKDL from source
RUN git clone https://github.com/yxzhan/rvizweb.git src/rvizweb -b 0.1.0
RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git src/orocos_kinematics_dynamics -b v1.5.1
RUN cd src/orocos_kinematics_dynamics && git submodule update --init
# Rebuild ROS workspace
USER root
RUN apt-get update
RUN rosdep install -y --ignore-src --from-paths ./ -r
USER ${NB_USER}
# RUN catkin clean --yes
RUN catkin build

# --- Precompile and cache LISP code ---
SHELL ["/bin/bash", "-c"]
RUN rm -rf ${HOME}/.local/share/jupyter/kernels/common-lisp
RUN /usr/bin/sbcl --load ${IAI_WS}/src/cram/jupyter/sbcl-jupyter-kernel-installer.lisp

RUN sed -i '3d' ${HOME}/workspace/ros/src/cram/cram_demos/cram_projection_demos/resource/household/open_box.obj
RUN sed -i '3d' ${HOME}/workspace/ros/src/cram/cram_demos/cram_projection_demos/resource/household/bowl.obj
RUN sed -i '3d' ${HOME}/workspace/ros/src/cram/cram_demos/cram_projection_demos/resource/household/cup.obj

# Clone this repository and set it as the working directory
WORKDIR /home/${NB_USER}
ADD https://api.github.com/repos/yxzhan/cram_teaching/git/refs/heads/main version.json
RUN git clone -b main https://github.com/yxzhan/cram_teaching.git repo

# Overwrite the entrypoint, and it has to end with `exec "$@"`. 
# Do not start the juptyerlab server in the entrypoint script, it should be launched by the jupyterhub.
RUN chmod +x ${HOME}/repo/binder/init.sh

WORKDIR ${HOME}/repo/
EXPOSE 8888
ENTRYPOINT ["/home/jovyan/repo/binder/init.sh"]
