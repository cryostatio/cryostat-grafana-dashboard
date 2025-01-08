FROM quay.io/centos/centos:stream9

EXPOSE 3000

RUN dnf install -y grafana && /usr/sbin/grafana cli plugins install yesoreyeram-infinity-datasource

COPY --chown=grafana:grafana \
    dashboards.yaml \
    dashboards/*.dashboard.json \
    /etc/grafana/provisioning/dashboards/

COPY --chown=grafana:grafana \
    datasource.yaml \
    /etc/grafana/provisioning/datasources/

COPY --chown=grafana:grafana \
    grafana.ini \
    /etc/grafana/grafana.ini

COPY --chown=grafana:grafana \
    entrypoint.bash \
    /usr/share/grafana

WORKDIR /usr/share/grafana
ENV GF_PATHS_HOME=/usr/share/grafana
ENV HOME=/usr/share/grafana
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini
# Listen address of jfr-datasource
ENV JFR_DATASOURCE_URL "http://0.0.0.0:8080"

USER grafana

ENTRYPOINT [ "/usr/share/grafana/entrypoint.bash" ]
