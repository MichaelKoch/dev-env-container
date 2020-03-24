FROM ubuntu:18.04 
RUN apt-get update && apt-get install -y openssh-server   curl dirmngr apt-transport-https software-properties-common lsb-release ca-certificates default-jre-headless git  apt-transport-https\
    && curl -sL https://deb.nodesource.com/setup_12.x |  bash -  && \
    apt -y install nodejs && \
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb 
 

RUN add-apt-repository universe && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1

ENV PASSWORD="CHANGE_ME" 
RUN mkdir /var/run/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
COPY ./scripts /scripts
COPY ./etc /etc
RUN chmod  777  /scripts -R \ 
    && chmod 600 /etc/ssh/* \ 
    && chmod 600 /etc/ssh/*.* \
    && mkdir /workspace \
    &&  apt-get autoremove  \
    && apt-get clean

WORKDIR /workspace
ENTRYPOINT /scripts/startup.sh
