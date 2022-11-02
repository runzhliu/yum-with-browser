# syntax=docker/dockerfile-upstream:1-labs
FROM centos:7

WORKDIR /srv/yum

# https://github.com/moby/moby/issues/16058#issuecomment-881901519
RUN <<-EOF cat >> /server.sh
    #!/usr/bin/env sh \
    set -x
    nohup crond &&
    python -m SimpleHTTPServer 8080
EOF

RUN <<-EOF cat >> /cron.sh
    #!/usr/bin/env sh
    set -x
    if [ ! -d "/srv/yum/repodata" ]; then
       createrepo -pdo /srv/yum/ /srv/yum/
    fi
    cd /srv/yum && createrepo --update .
EOF

RUN yum install -y createrepo crontabs && chmod +x /server.sh /cron.sh && \
 echo '*/1 * * * * /bin/sh /cron.sh >> /var/log/yum_crontab.log' > /var/spool/cron/root

CMD "/server.sh"