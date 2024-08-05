FROM docker.io/grafana/grafana:11.1.3

EXPOSE 3000

RUN grafana cli plugins install yesoreyeram-infinity-datasource

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
