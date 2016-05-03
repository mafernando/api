FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /api
WORKDIR /api

ENV RACK_ENV=development
ENV RAILS_ENV=development
ENV DEVISE_SECRET_KEY=I_AM_INSECURE_CHANGE_ME
ENV SECRET_KEY_BASE=I_AM_INSECURE_CHANGE_ME

COPY . /api/

RUN bundle install
RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile

# Note: Don't forget you have to run the migrations manually, by SSH'ing
# into the web server and running the following:
# rake db:migrate && rake db:seed && rake setup:demo

EXPOSE 3000

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
