########################################################################
# Dockerfile, ABr
# Custom image for Jenkins slave to support compliance-masonry
FROM openshift/jenkins-slave-base-centos7

MAINTAINER Andrew Bruce <andy@softwareab.net>

ENV MAVEN_VERSION=3.3 \
    GRADLE_VERSION=3.5 \
    NODEJS_VERSION=4.4 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin:$HOME/.npm-global/bin:$PATH:/opt/gradle-3.5/bin \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    FEDRAMP_TEMPLATER_IMAGE="github.com/opencontrol/fedramp-templater" \
    GO_PATH="/usr/local/go"

# Install NodeJS
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Install Maven
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel rh-maven33*" && \
    yum install -y centos-release-scl-rh && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    rpm -V ${INSTALL_PKGS//\*/} && \
    rpm -e java-1.7.0-openjdk --nodeps || true && \
    rpm -e java-1.7.0-openjdk-devel --nodeps || true && \
    rpm -e java-1.7.0-openjdk-headless --nodeps || true && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 && \
    mkdir -p $HOME/.gradle

# install calibre
RUN yum install -y mesa-libGL && \
    curl -q -k https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ADD ./contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD ./contrib/bin/configure-slave /usr/local/bin/configure-slave
ADD ./contrib/settings.xml $HOME/.m2/
ADD ./contrib/init.gradle $HOME/.gradle/

# install gitbook / docxtemplater after all else
RUN source /usr/local/bin/scl_enable && \
    npm install -g gitbook-cli docxtemplater

# setup java jars for groovy support
RUN mkdir $HOME/scripts
ADD ./assets/lcl-java-helpers.sh $HOME/scripts/
RUN $HOME/scripts/lcl-java-helpers.sh groovy-jars $HOME
ADD ./assets/.groovyrc $HOME/

# install golang and fedramp-templater
RUN yum install -y libxml2-devel && \
    curl https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | tar xz -C /usr/local && \
    mkdir -p /etc/profile.d && \
    echo 'pathmunge /usr/local/go/bin' > /etc/profile.d/golang-env.sh && \
    echo 'pathmunge /usr/local/bin' >> /etc/profile.d/golang-env.sh && \
    chmod +x /etc/profile.d/golang-env.sh && \
    export PATH="$PATH:$GO_PATH/bin" && \
    go get github.com/jbowtie/gokogiri && \
    go get $FEDRAMP_TEMPLATER_IMAGE && \
    cp $(find / -name fedramp-templater -type f | head -n 1) /usr/local/bin/

# set perms
RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

