FROM ruby:3-slim

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile rails_machine.gemspec ./
COPY lib/rails_machine/version.rb lib/rails_machine/version.rb

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rspec"]
