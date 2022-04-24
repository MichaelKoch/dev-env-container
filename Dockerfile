FROM ubuntu:20.04
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y rsyslog iputils-ping nginx openssh-server curl apt-transport-https software-properties-common lsb-release ca-certificates default-jre-headless git  apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_16.x |  bash -  && \
    apt -y install nodejs 
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt update && \
    apt install -y docker-ce-cli

RUN  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
     dpkg -i packages-microsoft-prod.deb && \
     add-apt-repository universe && \
     apt-get update && \
     apt-get install -y dotnet-sdk-3.1 dotnet-sdk-6.0 && \
     apt-get autoremove  && \
     apt-get clean && \
     mkdir /var/run/sshd



RUN curl https://baltocdn.com/helm/signing.asc |  apt-key add - && \
    apt-get install apt-transport-https --yes && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install helm


RUN  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add - && \
     echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list && \
     apt-get update
     apt-get install -y kubectl


EXPOSE 22 80 443
ENV USERNAME="root" 
ENV PASSWORD="CHANGE_ME" 

COPY ./scripts /scripts
COPY ./etc /etc

RUN    chmod  777  /scripts -R \ 
    && chmod 600 /etc/ssh/* \ 
    && chmod 600 /etc/ssh/*.* 

ENTRYPOINT /scripts/startup.sh
