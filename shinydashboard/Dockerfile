FROM rocker/shiny
    
RUN  R -e "install.packages(c('shinydashboard','magrittr', 'plyr', 'dplyr', 'tidyr', 'ggplot2', 'shinyjs'), repos='http://cran.rstudio.com/')"

COPY apps/first_app.R /srv/shiny-server/app.R
RUN rm /srv/shiny-server/index.html
RUN rm -rf /srv/shiny-server/sample-apps

CMD ["/usr/bin/shiny-server.sh"]
