# yum-with-browser

## Overview

[yum-with-browser](https://github.com/runzhliu/yum-with-browser) 目的是解决在 k8s 集群里一些 yum 源的问题。

为什么会有这个问题呢，因为通常来说 k8s 集群都只有集群网络，并不能直接通 Internet，甚至是公司的 LAN 都不一定能通。所以有些同学在使用 k8s 部署应用的时候，尤其是把 k8s 当成虚拟机来用的同学，会觉得装软件很麻烦，因为通常的流程可能是只能在 Dockerfile 里就把需要安装的软件安装好，比如vim, curl 之类的。

这个项目没有什么代码，仅仅是通过部署一个 k8s 工作负载，来部署一个私有化的 yum 源，并且**提供文件浏览器**的管理，这真的很重要，相比于常见的用Nginx 或者 httpd 来创建一个私有化的源，有文件管理器的 web 浏览器实在是太好了（当然前提是至少能够通过Nodeport把服务暴露出来）。

## 部署

部署很简单，给出了一个用临时存储的 [yum-with-browser.yaml](yum-with-browser.yaml)，所有的逻辑都在[Dockerfile](Dockerfile), 启动之后，filebrowser 的默认 NodePort 端口是32600，如果 yum-with-browser 是在集群中长期使用的源，那么建议还是用一个持久化存储的方案，将 rpm 包放起来。

```shell
kubectl apply -f yum-with-browser.yaml
````

下面是使用的方法，yum 源是通过 Service 的8080端口暴露的。

```shell
# 容器内访问只需要svc名，默认端口8080即可
cat >> /etc/yum.repos.d/sre.repo <<EOF
[sre]
name=sre yum repos
baseurl=http://yum-with-browser:8080
enable=1
gpgcheck=0
EOF
# 上传一个bash的rpm包
yum --disableexcludes=sre install bash -y
```

之后随便创建一个 centos 的 Pod，可以直接进入 yum-with-browser 里的 yum 容器，直接尝试安装，最后的结果如下。

![img_2.png](img_2.png)

## Notes

当然不是一个这样的仓库就能够允许在容器里装什么软件都可以的，这里跟容器内本身的基础镜像的Linux版本，内核版本，以及基础镜像里已经有的软件有关系。

重新编译镜像可以通过下面的命令来实现。

```shell
DOCKER_BUILDKIT=1 docker build -t runzhliu/yum-with-browser . --progress=plain
```

![img.png](img.png)

![img_1.png](img_1.png)
