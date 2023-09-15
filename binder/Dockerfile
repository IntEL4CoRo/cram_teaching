
FROM intel4coro/base-notebook:20.04-noetic-full-xpra

# Default ROS workspace
ENV HOME=/home/${NB_USER}
ENV ROS_WS=/home/${NB_USER}/workspace/ros
ENV REPO_DIR=${HOME}/cram_teaching
ARG CRAM_ROSINSTALL_FILE="${HOME}/.binder/cram-20.04-http.rosinstall"

# Copy git repository to image
COPY --chown=${NB_USER}:users . ${REPO_DIR}
COPY --chown=${NB_USER}:users ./binder ${HOME}/.binder

USER ${NB_USER}
 
RUN pip install pyyaml==5.3.1
WORKDIR ${ROS_WS}/src
# Install CRAM && Delete .git folder to reduce image size.
RUN wstool init \
    && wstool merge ${CRAM_ROSINSTALL_FILE} \
    && wstool update \
    && rm -rf */.git
# Install CommonLisp kernel. 
RUN catkin_create_pkg jupyter \
    && cd jupyter \
    && wstool init \
    && wstool merge ${REPO_DIR}/jupyter/common-lisp-jupyter.rosinstall \
    && wstool update \
    && rm -rf */.git
# Install PyKDL
WORKDIR ${ROS_WS}/src
RUN git clone https://github.com/orocos/orocos_kinematics_dynamics.git orocos_kinematics_dynamics -b v1.5.1 \
    && cd orocos_kinematics_dynamics && git submodule update --init
# Install dependencies and build workspace
USER root
RUN rosdep update \
    && rosdep install -y --ignore-src --from-paths ./ -r \
    && rosdep fix-permissions
USER ${NB_USER}
RUN catkin build

RUN echo "source ${ROS_WS}/devel/setup.bash" >> /home/${NB_USER}/.bashrc

# Intall CommonLisp kernel.
ENV ROSLISP_PACKAGE_DIRECTORIES=${ROS_WS}/devel/share/common-lisp
RUN source ${ROS_WS}/devel/setup.bash \
    &&  /usr/bin/sbcl --load ${REPO_DIR}/jupyter/sbcl-jupyter-kernel-installer.lisp

# # Precompile and cache LISP code for demo notebooks
RUN source ${ROS_WS}/devel/setup.bash \
    && xvfb-run /usr/bin/sbcl --load ${HOME}/.binder/pre-compile.lisp
RUN git config --global --add safe.directory ${REPO_DIR}

WORKDIR ${REPO_DIR}/
# Overwrite the entrypoint, and it has to end with `exec "$@"`.
# Do not start the juptyerlab server in the entrypoint script, it should be launched by the binderhub.
COPY --chown=${NB_USER}:users binder/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["start-notebook.sh"]