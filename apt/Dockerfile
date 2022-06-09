# syntax=docker/dockerfile-upstream:1-labs
FROM ubuntu:20.04

# https://developer.aliyun.com/mirror/ubuntu
RUN <<-EOF cat > /etc/apt/sources.list
    deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

    deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

    deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

    # deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
    # deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

    deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF

# https://www.jianshu.com/p/60e1aa37f9fb
RUN apt-get update && apt-get install -y dpkg-dev curl sudo

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
          && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
          && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
                sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
                sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt-get update && apt-get install -y python && apt-get install --download-only -y nvidia-docker2 docker
WORKDIR /var/
RUN mkdir -p /var/sre-apt/ && cp /var/cache/apt/archives/*.deb /var/sre-apt/
RUN dpkg-scanpackages sre-apt /dev/null | gzip -9c > sre-apt/Packages.gz

RUN <<-EOF cat >> /server.sh
    #!/usr/bin/env sh \
    set -x
    python -m SimpleHTTPServer 8080
EOF

RUN chmod +x /server.sh

CMD "/server.sh"