FROM alpine as downloader
ARG RDF4J_VERSION="2.4.0"

# Download the release and then extract that
RUN apk add --no-cache curl unzip

RUN curl -o /tmp/rdf4j.zip http://ftp.osuosl.org/pub/eclipse/rdf4j/eclipse-rdf4j-2.4.0-sdk.zip && \
    mkdir /extracted/ && \
    cd /extracted/ && \
    unzip /tmp/rdf4j.zip && \
    mv eclipse-rdf4j-* rdf4j

FROM tomcat:8-alpine
COPY --from=downloader /extracted/rdf4j/war/*.war /usr/local/tomcat/webapps/
