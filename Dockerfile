FROM ruby:2.3.1

RUN apt-get update \
  && apt-get install -y postgresql postgresql-server-dev-9.4 libpq-dev \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile .
ADD Gemfile.lock .

RUN bundle install --without test development

COPY . /usr/src/app

EXPOSE 4567

ENTRYPOINT ["rails", "server"]
