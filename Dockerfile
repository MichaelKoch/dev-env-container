FROM ubuntu:24.10 AS build
ARG USER_ID=1000
ARG GROUP_ID=1000


ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates software-properties-common wget python3


RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 


RUN curl -fsSL https://deb.nodesource.com/setup_20.x |bash - 
  
    
RUN apt-get update 
RUN apt-get install -y rsyslog iputils-ping nginx openssh-server \
    openjdk-17-jdk git \
    docker-ce-cli nodejs \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git





RUN  apt-get autoremove  -y && \
     apt-get clean -y 
COPY entrypoint.sh /entrypoint.sh
COPY ./etc /etc
RUN chmod +x /entrypoint.sh
RUN npm i -g npm@latest @angular/cli @nestjs/cli ejs
USER ubuntu:ubuntu
RUN curl https://pyenv.run | bash && /home/ubuntu/.pyenv/bin/pyenv install 3.10.16 
RUN echo 'export PYENV_ROOT=/ubuntu/.pyenv' >> ~/.bashrc && \
    echo 'export PATH=$PYENV_ROOT/bin:$PATH' >> ~/.bashrc &&\
    echo 'alias python=/home/ubuntu/.pyenv/versions/3.10.16/bin/python' >> ~/.bashrc &&\
    echo 'alias pip=/home/ubuntu/.pyenv/versions/3.10.16/bin/pip' >> ~/.bashrc 



