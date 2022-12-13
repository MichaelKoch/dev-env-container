FROM ubuntu:22.04 as BUILD
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
run apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates software-properties-common wget node-gyp

# RUN curl -sL https://deb.nodesource.com/setup_16.x |  bash -  

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 

RUN  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
     dpkg -i packages-microsoft-prod.deb && \
     add-apt-repository universe

RUN curl https://baltocdn.com/helm/signing.asc |  apt-key add - && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list 

RUN  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add - && \
     echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://deb.nodesource.com/setup_16.x |bash - 
  
    
RUN apt-get update && apt-get install -y rsyslog iputils-ping nginx openssh-server \
    default-jre-headless git \
    kubectl helm \
    dotnet-sdk-6.0 azure-functions-core-tools-4 \
    docker-ce-cli  fail2ban

RUN apt-get install -y nodejs

RUN  apt-get autoremove  -y && \
     apt-get clean -y && \
     mkdir /var/run/sshd


FROM BUILD

EXPOSE 22 80 443
ENV USERNAME="root" 
ENV PASSWORD="CHANGE_ME" 

COPY ./scripts /scripts
COPY ./etc /etc

RUN    chmod  777  /scripts -R \ 
    && chmod 600 /etc/ssh/* \ 
    && chmod 600 /etc/ssh/*.* 

ENTRYPOINT /scripts/startup.sh
