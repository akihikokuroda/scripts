#FROM rastasheep/ubuntu-sshd:18.04
FROM ubuntu:disco

RUN apt-get update
RUN apt-get remove -y docker docker-engine docker.io
RUN apt-get install -y emacs git docker.io curl build-essential vim
# install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
# install go
RUN curl -O -L https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz;tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz; echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
RUN mkdir -p /root/go/bin; mkdir /root/go/src; echo 'export GOPATH=/root/go' >> $HOME/.profile;  echo 'export PATH=$PATH:/root/go/bin' >> $HOME/.profile
# install dep
RUN . /root/.profile; curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
# install KO
RUN . /root/.profile; GO111MODULE=on go get github.com/google/ko/cmd/ko
RUN  echo 'export KO_DOCKER_REPO="docker.io/akihikokuroda"' >> $HOME/.profile
# install nodejs
RUN curl -O -L https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz
RUN mkdir -p /usr/local/lib/nodejs; tar -xJvf node-v12.13.0-linux-x64.tar.xz -C /usr/local/lib/nodejs
RUN echo 'export PATH=/usr/local/lib/nodejs/node-v12.13.0-linux-x64/bin:$PATH'  >> $HOME/.profile  
# git config
RUN git config --add --global user.name akihikokuroda; git config --add --global user.email akuroda@us.ibm.com
#generate ssh key
RUN ssh-keygen -t rsa -b 4096 -C "akuroda@us.ibm.com" -P "" -f /root/.ssh/id_rsa

# install sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
