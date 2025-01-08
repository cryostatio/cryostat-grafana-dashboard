FROM quay.io/centos/centos:stream9-minimal
ARG UID=101
ARG PORT=3000

WORKDIR /usr/share/grafana
ENV VERSION=10
ENV GF_PATHS_HOME=/usr/share/grafana
ENV HOME=/usr/share/grafana
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini

LABEL name="cryostat/cryostat-grafana-dashboard" \
      version="${VERSION}" \
      usage="podman run -d --name grafana -p ${PORT}:${PORT} -v grafana-data:${GF_PATHS_DATA} quay.io/cryostat/cryostat-grafana-dashboard" \
      maintainer="Cryostat Maintainers <cryostat-development@googlegroups.com>" \
      io.k8s.display-name="Grafana" \
      io.openshift.expose-services="3000:grafana" \
      io.openshift.tags="grafana,monitoring,dashboard"

RUN useradd -u ${UID} -g 0 -r -d $GF_PATHS_HOME -s /sbin/nologin grafana && \
    microdnf upgrade -y && \
    microdnf install -y --setopt=tsflags=nodocs grafana && \
    microdnf clean all && \
    chgrp -R 0 /etc/grafana /var/lib/grafana /var/log/grafana && \
    chmod -R g=u /var/lib/grafana /var/log/grafana && \
    /usr/sbin/grafana cli plugins install yesoreyeram-infinity-datasource

COPY --chown=grafana:grafana \
    dashboards.yaml \
    dashboards/*.dashboard.json \
    ${GF_PATHS_PROVISIONING}/dashboards/

COPY --chown=grafana:grafana \
    datasource.yaml \
    ${GF_PATHS_PROVISIONING}/datasources/

COPY --chown=grafana:grafana \
    grafana.ini \
    ${GF_PATHS_CONFIG}

COPY --chown=grafana:grafana \
    entrypoint.bash \
    /usr/bin/run-grafana

# Listen address of jfr-datasource
ENV JFR_DATASOURCE_URL "http://0.0.0.0:8080"

USER ${UID}

EXPOSE ${PORT}

ENTRYPOINT [ "/usr/bin/run-grafana" ]
