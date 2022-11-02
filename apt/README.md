# 自建apt源


```shell
echo 'deb [trusted=yes] http://10.11.36.21:30080 sre-apt/' > /etc/apt/sources.list.d/sre-apt.list
apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/sre-apt.list
apt-get install -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/sre-apt.list -y nvidia-docker2
```