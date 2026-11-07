FROM docker.io/grafana/grafana:9.5.21@sha256:ec106c7d446c88377f9d6c4cd363361b5846c361a28f5669d1b5e92926d94891

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
