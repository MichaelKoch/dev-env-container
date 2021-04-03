FROM ubuntu:20.04 as build
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y dnsutils telnet iputils-ping openssh-server curl dirmngr apt-transport-https software-properties-common lsb-release ca-certificates default-jre-headless git  apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_14.x |  bash -  && \
    apt -y install nodejs 


RUN  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 dotnet-sdk-5.0 && \
    apt-get autoremove  && \
    apt-get clean && \
    mkdir /var/run/sshd



FROM build
EXPOSE 22
ENV PASSWORD="CHANGE_ME" 
COPY ./scripts /scripts
COPY ./etc /etc
RUN chmod  777  /scripts -R \ 
    && chmod 600 /etc/ssh/* \ 
    && chmod 600 /etc/ssh/*.* \
    && mkdir /workspace 


ENTRYPOINT /scripts/startup.sh
