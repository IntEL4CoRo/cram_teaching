# docker build -f binder/Dockerfile -t cram_teaching:legacy .
FROM arthurniedz/cram:devel

FROM intel4coro/base-notebook:20.04-noetic-full-xpra

ENV REPO_DIR=/home/${NB_USER}/cram_teaching
ENV IAI_WS=/home/${NB_USER}/workspace/ros

USER ${NB_USER}
# COPY CRAM workspace
COPY --from=0 --chown=${NB_USER}:users /home/workspace/ros/src/. ${IAI_WS}/src/
RUN cd ${IAI_WS}/src/jupyter/common-lisp-jupyter && git pull

WORKDIR ${IAI_WS}
# Rebuild ROS workspace
USER root
RUN rosdep update && \
    rosdep install -y --ignore-src --from-paths ./ -r && \
    rosdep fix-permissions

USER ${NB_USER}
RUN catkin build

# Intall CommonLisp kernel.
RUN source ${IAI_WS}/devel/setup.bash && \
    /usr/bin/sbcl --load ${IAI_WS}/src/cram/jupyter/sbcl-jupyter-kernel-installer.lisp && \
    xvfb-run /usr/bin/sbcl --load ${REPO_DIR}/binder/pre-compile.lisp

COPY --chown=${NB_USER}:users ./binder/entrypoint.sh /
COPY --chown=${NB_USER}:users ./binder/webapps.json ${IAI_WS}/src/rvizweb/webapps/app.json 
COPY --chown=${NB_USER}:users ./ ${REPO_DIR}

WORKDIR ${REPO_DIR}
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "jupyter", "lab", "--allow-root", "--NotebookApp.token=''", "--no-browser", "--ip=0.0.0.0" ]
RUN pip install https://raw.githubusercontent.com/yxzhan/jupyterlab-rviz/master/dist/jupyterlab_rviz-0.3.1.tar.gz

