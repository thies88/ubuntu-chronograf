# Runtime stage
FROM thies88/ubuntu-base

#Env vars
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Thies88"

#Define install variables
ARG APT=chronograf
ARG APT_DEPS=""
ENV APP_DEBUGMODE=0

#APP ENV vars to pass to /etc/servcies.d/APP/run
ENV HOST="0.0.0.0" \
PORT="8888" \
INFLUXDB_URL="" \
INFLUXDB_USERNAME="" \
INFLUXDB_PASSWORD="" \
TLS_CERTIFICATE="" \
TLS_PRIVATE_KEY="" \
KAPACITOR_URL="" \
KAPACITOR_USERNAME="" \
KAPACITOR_PASSWORD=""

# --basepath=/config/chronograf -b /config/chronograf/chronograf-v1.db -c /usr/share/chronograf/canned
ENV APP1="chronograf --host=${HOST} --port=${PORT} -b /var/lib/chronograf/chronograf-v1.db -c /usr/share/chronograf/canned --cert=/config/keys/cert.crt --key=/config/keys/cert.key "

RUN \
 echo "**** install application and needed packages ****" && \
 echo "deb https://repos.influxdata.com/ubuntu ${REL} stable" > /etc/apt/sources.list.d/influxdb.list && \
 curl -o /tmp/influxdb.key https://repos.influxdata.com/influxdb.key && \
 apt-key add /tmp/influxdb.key && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	${APT_DEPS} \
	${APT} && \	
echo "**** cleanup ****" && \
apt-get autoremove -y --purge && \
apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/cache/apt/* \
	/var/tmp/* \
	/var/log/* \
	/usr/share/doc/* \
	/usr/share/info/* \
	/var/cache/debconf/* \
	/usr/share/man/* \
	/usr/share/locale/*
	
# add local files
COPY root/ /

EXPOSE 8888/tcp

ENTRYPOINT ["/bin/bash", "/init"]
