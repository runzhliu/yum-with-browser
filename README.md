# yum-with-browser

## Overview

目的是解决在k8s集群里一些yum源的问题。

为什么会有这个问题呢，因为通常来说k8s集群都只有集群网络，并不能直接通Internet，甚至是公司的LAN都不一定能通。所以有些同学在使用k8s部署应用的时候，尤其是把k8s当成虚拟机来用的同学，会觉得装软件很麻烦，因为通常的流程可能是只能在Dockerfile里就把需要安装的软件安装好，比如vim,
curl之类的。

这个项目没有什么代码，仅仅是通过部署一个k8s工作负载，来部署一个私有化的yum源，并且**提供文件浏览器**的管理，这真的很重要，相比于常见的用Nginx
或者httpd来创建一个私有化的源，有文件管理器的web浏览器实在是太好了（当然前提是至少能够通过Nodeport把服务暴露出来）。

## 部署

部署很简单，我甚至只写了一个Pod，Deployment都懒得搞了，所有的逻辑都在[Dockerfile](Dockerfile)

```shell
kubectl run yum-file-browser --image=runzhliu/filebrowser --image-pull-policy=Always
kubectl expose po yum-with-browser --name=yum-with-browser --port=80 --target-port=80 --type=NodePort
kubectl expose po yum-with-browser --name=yum --port=80 --target-port=8080

cat >> /etc/yum.repos.d/sre.repo <<EOF
[sre]
name=sre yum repos
baseurl=http://yum
enable=1
gpgcheck=0
EOF
# 上传一个rpm包
yum --disablerepo=* --enablerepo=sre install vim -y
```

## Notes

当然不是一个这样的仓库就能够允许在容器里装什么软件都可以的，这里跟容器内本身的基础镜像的Linux版本，内核版本，以及基础镜像里已经有的软件有关系。

重新编译镜像可以通过下面的命令来实现。

```shell
DOCKER_BUILDKIT=1 docker build -t runzhliu/yum-with-browser . --progress=plain
```