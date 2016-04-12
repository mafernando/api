FROM ruby:2.2.3
RUN git config --global url."https://github.com".insteadOf git://github.com
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev npm nodejs-legacy
RUN mkdir /api
WORKDIR /api

RUN npm install -g gulp bower

COPY Gemfile /api/
COPY Gemfile.lock /api/

COPY . /api/
RUN bundle install

RUN npm install
RUN bower install --allow-root --config.interactive=false
RUN gulp build
