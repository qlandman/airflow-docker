# Custom Dockerfile
FROM apache/airflow:1.10.10

# Install mssql support & dag dependencies
USER root
RUN apt-get update -yqq \
    && apt-get install -y gcc freetds-dev \
    && apt-get install -y git procps \ 
    && apt-get install -y vim
RUN pip install apache-airflow[mssql,mssql,ssh,s3,slack] 
RUN pip install azure-storage-blob sshtunnel google-api-python-client oauth2client \
    && pip install git+https://github.com/infusionsoft/Official-API-Python-Library.git \
    && pip install rocketchat_API

# Additional dependencies
RUN pip install --user numba==0.49.*

# This fixes permission issues on linux. 
# The airflow user should have the same UID as the user running docker on the host system.
# make build is adjust this value automatically
ARG DOCKER_UID
RUN \
    : "${DOCKER_UID:?Build argument DOCKER_UID needs to be set and non-empty. Use 'make build' to set it automatically.}" \
    && usermod -u ${DOCKER_UID} airflow \
    && find / -path /proc -prune -o -user 50000 -exec chown -h airflow {} \; \
    && echo "Set airflow's uid to ${DOCKER_UID}"

USER airflow