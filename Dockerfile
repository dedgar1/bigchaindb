FROM rethinkdb:2.3

# From http://stackoverflow.com/a/38553499

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

RUN apt-get -y install python3 python3-pip libffi-dev
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools

RUN mkdir -p /usr/src/app

COPY . /usr/src/app/

WORKDIR /usr/src/app

RUN pip3 install --no-cache-dir -e .

WORKDIR /data

ENV BIGCHAINDB_CONFIG_PATH /data/.bigchaindb
ENV BIGCHAINDB_SERVER_BIND 0.0.0.0:9984
# BigchainDB Server doesn't need BIGCHAINDB_API_ENDPOINT any more
# but maybe our Docker or Docker Compose stuff does?
# ENV BIGCHAINDB_API_ENDPOINT http://bigchaindb:9984/api/v1

ENTRYPOINT ["bigchaindb", "--dev-start-rethinkdb", "--dev-allow-temp-keypair"]

CMD ["start"]

EXPOSE 8080 9984 28015 29015
