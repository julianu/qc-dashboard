FROM rocker/shiny

RUN  R -e "install.packages(c('shinydashboard', 'magrittr', 'plyr', 'dplyr', 'tidyr', 'ggplot2', 'shinyjs', 'DT'), repos='http://cran.rstudio.com/')"

COPY apps/ /srv/shiny-server/

RUN rm /srv/shiny-server/index.html
RUN rm -rf /srv/shiny-server/sample-apps

CMD ["/usr/bin/shiny-server.sh"]
