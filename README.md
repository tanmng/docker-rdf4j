# tanmng/rdf4j - rdf4j Docker image

[Eclipse RDF4J](http://rdf4j.org/about/) (formerly known as Sesame) is a powerful Java framework for processing and handling RDF data. This includes creating, parsing, scalable storage, reasoning and querying with RDF and Linked Data. It offers an easy-to-use API that can be connected to all leading RDF database solutions. 

This image provides the RDF4J Server, and Workbench running inside Tomcat.

## Environment Variables

Since this image uses the [official Tomcat image](https://hub.docker.com/_/tomcat/) internally, you can just use the same environment variables as you use for Tomcat

* `JAVA_OPTS`, this environment variable is used to configure any potential options that you wish to set onto the Java process running inside the container

### Example of using `JAVA_OPTS`

* `JAVA_OPTS='-Xmx4g -Xms4g'`  - Set the limit to heap memory usage of Java
* `JAVA_OPTS='-Dorg.eclipse.rdf4j.appdata.basedir=/data/'` - Use the directory `/data/` to store the data for rdf4j-server

## rdf4j-workbench to access rdf4j-server

When you first access rdf4j-workbench, it will try to access the rdf4j-server by using the domain name which you are using to access rdf4j-workbench (eg. if you are accessing rdf4j-workbench as `http://localhost:8080/rdf4j-workbench`, the workbench will try to access server by using `http://localhost:8080/rdf4j-server`. Since on the container, the domain name `localhost` on the container point to itself, rdf4j will be able to access the server.

However, if you strengthen your security by placing the server behind some layers of security, or when you deploy this system to production. Chances are, you will be accessing rdf4j-workbench using a domain name with which the workbench cannot use to connect to its server. In such case, you can either loosen up your security to allow such connection, or wait for rdf4j-workbench to gives up during it retry process. After that, you can configure rdf4j-workbench to connect to the server by `http://localhost:8080/rdf4j-server` per normal. Note that this setting is stored on your browser cookie, so anyone who connect to rdf4j-workbench will have to go through the same process.

## Permanent storage

Unless you specify the datadir for rdf4j-server by using the properti `org.eclipse.rdf4j.appdata.basedir`, by default rdf4j-server will store all its data in `/root/.RDF4J/server`, thus, you can either mount a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#data-volumes) to the designated directory or [bind mount](https://docs.docker.com/storage/bind-mounts/) a directory from the host onto the container. In either case, that will help with preserving the data that you have in you rdf4j

> One note on rdf4j-workbench: quite strangely, some of the settings/data that you have set to your rdf4j-workbench are stored as cookie in your browser.

## Example Usage

I recommend you to use [Docker-compose](https://docs.docker.com/compose/) / [Docker swarm](https://docs.docker.com/engine/swarm/) to launch Chevereto in conjunction with a MySQL database. A sample of docker-compose.yaml can be found
below.

Once the container is running, you can access the RDF4j Server and workbench by going to [http://localhost:8080/rdf4j-server](http://localhost:8080/rdf4j-server) and [http://localhost:8080/rdf4j-workbench](http://localhost:8080/rdf4j-workbench) respectively (assuming you are exposing the port `8080` of the container to port `8080` on your host as shown in the example below).

### Docker compose

```yaml
version: '3'

services:
  rdf4j:
    image: nmtan/rdf4j
    restart: always
    environment:
      JAVA_OPTS: '-Xmx4g -Xms4g'
    ports:
      - 8080:8080
```

Once `docker-compose.yaml` is ready, you can run

```bash
docker-compose up
```

To run the service

### Standalone

```bash
docker run -it --name rdf4j -d \
    -p 8080:8080 \
    -e JAVA_OPTS='-Xmx4g -Xms4g'
    nmtan/rdf4j
```

## Note on documentation

The documentation provided here aim mainly at to show you how to get the application up and running. Documentation on configuring or using rdf4j are provided in great details [here](http://docs.rdf4j.org/server-workbench-console/) and [here](http://docs.rdf4j.org/).

## Note on multi platform

It is feasible to run a Docker container image on different architectures. For now, I don't yet have the time to work on this, but will make sure to include that in future releases.
