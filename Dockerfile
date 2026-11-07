FROM docker.io/grafana/grafana:10.4.3@sha256:b7fcb534f7b3512801bb3f4e658238846435804deb479d105b5cdc680847c272

EXPOSE 3000

RUN grafana-cli plugins install grafana-simple-json-datasource

COPY --chown=grafana:root \
	dashboards.yaml \
	dashboards/*.dashboard.json \
	/etc/grafana/provisioning/dashboards/

COPY --chown=grafana:root \
    datasource.yaml \
    /etc/grafana/provisioning/datasources/

COPY --chown=grafana:root \
    grafana.ini \
    /etc/grafana/grafana.ini

# Listen address of jfr-datasource
ENV JFR_DATASOURCE_URL "http://0.0.0.0:8080"

# User grafana
USER 472

ENTRYPOINT [ "/run.sh" ]
