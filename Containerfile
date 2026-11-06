FROM docker.io/grafana/grafana:7.5.15@sha256:0a4a31f1922e01645702401ac550fd89346244e2868cb9620f32f87fac0b7a5a

EXPOSE 3000

RUN grafana-cli plugins install grafana-simple-json-datasource

COPY --chown=grafana:root \
	dashboards.yaml \
	dashboard.json \
	/etc/grafana/provisioning/dashboards/

COPY --chown=grafana:root \
    datasource.yaml \
    /etc/grafana/provisioning/datasources/

# Listen address of jfr-datasource
ENV JFR_DATASOURCE_URL "http://0.0.0.0:8080"

USER grafana
ENTRYPOINT [ "/run.sh" ]
