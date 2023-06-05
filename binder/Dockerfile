FROM arthurniedz/cram:test

FROM yxzhan/intel4coro:jupyterhub-0.1.7

ARG IAI_WS=/home/workspace/ros

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
RUN git clone https://github.com/yxzhan/rvizweb.git src/rvizweb -b 0.1.1
RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git src/orocos_kinematics_dynamics -b v1.5.1
RUN cd src/orocos_kinematics_dynamics && git submodule update --init
# Rebuild ROS workspace
USER root
RUN apt-get update && rosdep install -y --ignore-src --from-paths ./ -r
USER ${NB_USER}
# RUN catkin clean --yes
RUN catkin build

# Precompile and cache LISP code
RUN rm -rf ${HOME}/.local/share/jupyter/kernels/common-lisp ${HOME}/.cache/common-lisp
RUN /usr/bin/sbcl --load ${IAI_WS}/src/cram/jupyter/sbcl-jupyter-kernel-installer.lisp
RUN xvfb-run /usr/bin/sbcl --dynamic-space-size 4096 --load ${HOME}/work/pre-compile.lisp

# Fix 3d Meshes material files missing issue
RUN cd ${HOME}/workspace/ros/src/cram/cram_demos/cram_projection_demos/resource/household && \
    sed -i '3d' open_box.obj bowl.obj cup.obj

# Clone this repository and set it as the working directory
# Overwrite the entrypoint, and it has to end with `exec "$@"`.
# Do not start the juptyerlab server in the entrypoint script, it should be launched by the jupyterhub.
WORKDIR /home/${NB_USER}
ADD https://api.github.com/repos/yxzhan/cram_teaching/git/refs/heads/main version.json
RUN git clone -b main https://github.com/yxzhan/cram_teaching.git repo
RUN chmod +x ${HOME}/repo/binder/init.sh
# Compress texture files
# COPY --chown=${NB_USER}:users ./compress_textures.py ${HOME}/work
RUN /opt/conda/bin/python ${HOME}/repo/binder/compress_textures.py --img_path=${IAI_WS}/src/iai_maps/iai_apartment/meshes/ --max_size=512

RUN npm cache clean --force && pip cache purge && rm -rf ${HOME}/.cache/bower && mamba clean -ya

WORKDIR ${HOME}/repo/
EXPOSE 8888
ENTRYPOINT ["/home/jovyan/repo/binder/init.sh"]
