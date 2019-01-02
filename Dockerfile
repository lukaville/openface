FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    gfortran \
    git \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    libreadline-dev \
    pkg-config \
    software-properties-common \
    zip \
    sudo \
    curl \
    wget \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python3-numpy \
    python3-nose \
    python3-scipy \
    python3-pandas \
    python3-protobuf \
    python3-openssl \
    python3-opencv \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch; bash install-deps; ./install.sh

RUN cd ~/torch && ./install.sh && \
    cd install/bin && \
    ./luarocks install nn && \
    ./luarocks install dpnn && \
    ./luarocks install image && \
    ./luarocks install optim && \
    ./luarocks install optnet && \
    ./luarocks install csvigo && \
    ./luarocks install torchx && \
    ./luarocks install graphicsmagick && \
    ./luarocks install tds

RUN ln -s /root/torch/install/bin/* /usr/local/bin

ADD . /root/openface

RUN python3 -m pip install --upgrade --force pip
RUN cd ~/openface && \
    ./models/get-models.sh && \
    pip3 install dlib && \
    pip3 install -r requirements.txt && \
    python3 setup.py install && \
    pip3 install --user --ignore-installed -r demos/web/requirements.txt && \
    pip3 install -r training/requirements.txt

EXPOSE 8000 9000
CMD /bin/bash -l -c '/root/openface/demos/web/start-servers.sh'
