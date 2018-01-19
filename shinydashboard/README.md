Docker for Shiny Server
=======================

This is a Dockerfile for the implementation of the "QC Dashboard" in Shiny. It is based on the "rocker/shiny" image. The creation of the image "QC Dashboard" was launched during the EuBIC 2018 Hackathon.

The image is available from [Docker Hub](https://hub.docker.com/r/mwalzer/shinyqcdashboard/).

## Usage:

To run a temporary container with Shiny Server:

```sh
docker run --rm -p 3838:3838 mwalzer/shinyqcdashboard
```


To expose a directory on the host to the container use `-v <host_dir>:<container_dir>`. The following command will use one `/srv/shinyapps` as the Shiny app directory and `/srv/shinylog` as the directory for Shiny app logs. Note that if the directories on the host don't already exist, they will be created automatically.:

```sh
docker run --rm -p 3838:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/shiny-server/ \
    mwalzer/shinyqcdashboard
```

If you have an app in /srv/shinyapps/appdir, you can run the app by visiting http://localhost:3838/appdir/. (If using boot2docker, visit http://192.168.59.103:3838/appdir/)


In a real deployment scenario, you will probably want to run the container in detached mode (`-d`) and listening on the host's port 80 (`-p 80:3838`):

```sh
docker run -d -p 80:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/shiny-server/ \
    mwalzer/shinyqcdashboard
```


## Trademarks

Shiny and Shiny Server are registered trademarks of RStudio, Inc.
