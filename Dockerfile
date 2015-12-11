FROM debian

# list of available versions: http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/
ENV SWARM_VERSION=2.0

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install openjdk-7-jdk git ssh-client apt-transport-https curl && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get -y install docker-engine && \
    curl -o /swarm.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar && \
    rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

CMD java -jar /swarm.jar -username $JENKINS_USERNAME -password $JENKINS_APIKEY -labels 'docker swarm'
