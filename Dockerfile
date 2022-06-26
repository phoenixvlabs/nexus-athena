FROM kalilinux/kali-bleeding-edge:amd64

ARG VERSION
ENV VERSION $VERSION
ARG BUILD_TIMESTAMP
ENV BUILD_TIMESTAMP $BUILD_TIMESTAMP

LABEL description="Custom Kali Linux Bleeding Edge repository Docker image configured with pre-installed packages such as Nmap, Wireshark, Metasploit Framework, and radare2."

VOLUME ["/var/run", "/var/lib/docker/volumes", "/nexus-bucket"]

RUN apt-get update -y -qq && \
    DEBIAN_FRONTEND=nonintereactive apt-get install -y --no-install-recommends -qq \
        vim \
        nmap \
        wireshark \
        git \
        metasploit-framework \
        make \
        gcc \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* 2> /dev/null

RUN git clone https://github.com/radareorg/radare2 && \
    sh radare2/sys/install.sh

RUN rm -rf radare2 2> /dev/null

RUN wget -O terraform-amd64.zip https://releases.hashicorp.com/terraform/1.2.3/terraform_1.2.3_linux_amd64.zip && \
    unzip terraform-amd64.zip && \
    mv terraform usr/local/bin && \
    touch ~/.bashrc && \
    terraform -install-autocomplete

RUN rm terraform-amd64.zip 2> /dev/null

EXPOSE 22/tcp

