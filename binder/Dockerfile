FROM arthurniedz/cram:test

USER root
RUN apt-get update && apt-get install -y curl xvfb
RUN pip install https://raw.githubusercontent.com/yxzhan/jupyterlab-rviz/master/release/jupyterlab_rviz-0.2.4.tar.gz
RUN pip install jupyter-server-proxy jupyterlab-git jlab-enhanced-cell-toolbar \
                cbor2 twisted cryptography==38.0.4 autobahn \
                pymongo Pillow pycryptodomex gnupg

WORKDIR /home/workspace/ros/
RUN git clone https://github.com/yxzhan/rvizweb.git src/rvizweb -b 0.1.0
RUN rosdep install -y --ignore-src --from-paths ./ -r
RUN catkin build

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER ${NB_USER}

WORKDIR /home/${NB_USER}
# ADD https://api.github.com/repos/yxzhan/cram_teaching/git/refs/heads/main version.json
RUN git clone -b main https://github.com/yxzhan/cram_teaching.git work
# RUN jupyter lab workspaces import /home/${NB_USER}/work/binder/workspace.json

WORKDIR /home/${NB_USER}/work/

ENTRYPOINT ["/home/jovyan/work/binder/init.sh"]
