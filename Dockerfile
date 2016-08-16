FROM debian

# list of available versions: http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/
ENV \
    SWARM_VERSION=2.2 \
    K8S_VERSION=1.3.5 \
    DOCKERSQUASH_VERSION=0.2.0

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install openjdk-7-jdk git ssh-client apt-transport-https curl wget && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get -y install docker-engine && \
    curl -o /swarm.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar && \
    wget https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    wget https://github.com/jwilder/docker-squash/releases/download/v${DOCKERSQUASH_VERSION}/docker-squash-linux-amd64-v${DOCKERSQUASH_VERSION}.tar.gz && \
    tar -C /usr/local/bin -xzvf docker-squash-linux-amd64-v${DOCKERSQUASH_VERSION}.tar.gz && \
    apt-get -y autoremove wget && \
    rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

CMD java -jar /swarm.jar -username $JENKINS_USERNAME -password $JENKINS_APIKEY -labels 'docker swarm'
