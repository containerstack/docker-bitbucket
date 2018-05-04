# Atlassian Bitbucket in a Docker container

This is a containerized installation of Atlassian Bitbucket with Docker.
The aim of this image is to keep the installation easy and as straight forward as possible.

It's possible to clone this repo and build the image on you're own machine, but if you think that's a waste of time ;-) there's a Automated Build in the Docker Hub that's based on this repo.

* [Docker Hub - Automated Build](https://hub.docker.com/r/containerstack/bitbucket/)
* [Atlassian Bitbucket latest build](https://confluence.atlassian.com/bitbucketserver/bitbucket-server-release-notes-872139866.html)
* [Oracle MySQL Connector J latest build](http://dev.mysql.com/downloads/connector/j/)
* [Atlassian Bitbucket](https://www.atlassian.com/software/bitbucket)

## Versions
Currently this repo have the following versions;
* 5.4.9 (latest - not yet tested)
* 5.4.0 (latest - tested)

Go to [Branches](https://github.com/remonlam/docker-bitbucket/branches) to see all different builds that are available.

## Use the Automated Build image for a TEST deployment

To quickly get started running a Bitbucket instance, use the following command:
```bash
docker run --detach \
           --name bitbucket \
           --publish 8090:8090 \
           remonlam/bitbucket:latest
```

Once the image has been downloaded and container is fully started (this could take a few minutes), browse to `http://[dockerhost]:8090` to finish the configuration and enter your trail/license key.

NOTE: It's not recommended to run Bitbucket this way because it does NOT have persistent storage, once the container is removed everything is gone!!
      Only use this methode for testing out Bitbucket!!

### What does all these options do?;
detach          runs the container in the background
name            gives the container a more useful name
publish         publish a port from the container to the outside world (docker node [outside] / container [inside])


## Use the Automated Build image for a PRODUCTION deployment;

In order to make sure that what ever you or you're team is creating in Bitbucket is persistent even when the container is recreated it's useful to make the "/var/atlassian/bitbucket" directory persistent.
```bash
docker run --detach \
           --name bitbucket \
           --volume "/persistent/storage/atlassian/bitbucket:/var/atlassian/bitbucket" \
           --env "CATALINA_OPTS= -Xms512m -Xmx4g" \
           --publish 8090:8090 \
           remonlam/bitbucket:latest
```

Once the image has been downloaded and container is fully started (this could take a few minutes), browse to `http://[dockerhost]:8090` to finish the configuration and enter your trail/license key.

### What does all these options do?;
| Option| Description|
| :------------- |:-------------|
|detach|*runs the container in the background*|
|name|*gives the container a more useful name*|
|volume|*maps a directory from the docker host inside the container*|
|env|*sets environment variables (this case it's for setting the JVM minimum/maximum memory 512MB<->2GB)*|
|publish|*publish a port from the container to the outside world (dockernode [outside] / container [inside])*|



## Issues, PR's and discussion

If you see an issues please create an [issue](https://github.com/remonlam/docker-bitbucket/issues/new) or even better fix it and create an [PR](https://github.com/remonlam/docker-bitbucket/compare) :-)
