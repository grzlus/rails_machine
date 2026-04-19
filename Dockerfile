FROM ruby:2.1-slim

RUN printf 'deb http://archive.debian.org/debian jessie main\ndeb http://archive.debian.org/debian-security jessie/updates main\n' \
      > /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update -qq && \
    apt-get -o Acquire::Check-Valid-Until=false install -y --force-yes --no-install-recommends \
      build-essential \
      libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

COPY Gemfile rails_machine.gemspec ./
COPY lib/rails_machine/version.rb lib/rails_machine/version.rb

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rspec"]
