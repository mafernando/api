FROM ruby:2.3.0
RUN git config --global url."https://github.com".insteadOf git://github.com
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RACK_ENV=development
ENV RAILS_ENV=development
ENV DEVISE_SECRET_KEY=I_AM_INSECURE_CHANGE_ME
ENV SECRET_KEY_BASE=I_AM_INSECURE_CHANGE_ME

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir /api
WORKDIR /api
ADD . /api/

# Only needed if running Docker as production
# RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile

EXPOSE 3000

CMD bash -c "bundle exec rake db:migrate && bundle exec rake db:reset && rake setup:demo && bundle exec rails s -p 3000 -b '0.0.0.0'"
