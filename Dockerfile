FROM ruby:3.2.2-bullseye

ENV DIR="/pnld"

RUN apt-get update -y && apt-get install -y wget gnupg

#adds posgresql repository
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' >  /etc/apt/sources.list.d/pgdg.list && \
    wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update -y && apt-get install -y postgresql-client-15 libpq-dev git make file gcc g++

WORKDIR ${DIR}

RUN groupadd -o -r pipefy --gid $(id -g) && \
    useradd --no-log-init --uid $(id -u) -r -o -g pipefy -md /home/pipefy pipefy

USER pipefy

COPY . ${DIR}

ADD --chown=pipefy:pipefy Gemfile* ${DIR}/

RUN bundle install

CMD [ "bash", "-c", "bin/rails server -p 3000 -b 0.0.0.0" ]