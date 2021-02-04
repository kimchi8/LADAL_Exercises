## Use a tag instead of "latest" for reproducibility
FROM rocker/binder:3.6.3
RUN R -e "install.packages('gradethis', repos = 'https://github.com/rstudio-education/gradethis')"

## Declares build arguments
ENV NB_USER rstudio
ENV NB_UID 1000
ENV VENV_DIR /srv/venv

ENV PATH ${VENV_DIR}/bin:$PATH
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
## Enable this to copy files from the binder subdirectory
## to the home, overriding any existing files.
## Useful to create a setup on binder that is different from a
## clone of your repository
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

## Run an install.R script, if it exists.
RUN if [ -f install.R ]; then R --quiet -f install.R; fi
