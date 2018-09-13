# Airtime multi-container Docker.

This is a multi-container docker build of the Sourcefabric Airtime Broadcast Software.
It's an aim to run the environment ready for production, with common media directories, database files etc mapped into the container(s) so data is persisted between rebuilds of the application.

It was loosely based on @okvic77's doker build, however I've pretty much rewritten all of it during the phase of 'splitting out' the containers, however thanks Okvic for the inspiration :)

---------------------------

### Overview:

The project consists of three main containers/components:

 - `airtime-core` - This is the main Airtime container, running the latest stable build distributed by Sourcefabric (as of September 2018) - Based on Ubuntu Trusty.
 - `airtime-rabbitmq` - A seperated RabbitMQ container based on Alpine Linux.
 - `airtime-postgres` - The database engine behind Airtime - It's also an Alpine Linux build in an attempt to be as 'lean and mean' as possible when it comes to system resources...

### Configuration:

You will want to edit the `docker-compose.yml` file and change some of the mappings to suit your needs.
If you're new to docker you should probably just change the `/localmusic:/external-media:ro` line to the directory on your Linux server where your media resides (Just replace `/localmusic` with the path to your media).

### Standing up:

It's pretty straightforward, just clone down the sources and stand up the container like so:

```bash
# Clone down sources
git clone https://github.com/ned-kelly/docker-airtime.git

# Stand up the container
docker-compose up -d --build

```

Once the containers have been stood up you should be able to access the project directly in your browser...

### Accessing:

Just go to http://server-ip:8882/ (remove port 8882 if you mapped 80:80 in your docker-compose file...)

Default Username: `admin`
Default Password: `admin`

Have fun!