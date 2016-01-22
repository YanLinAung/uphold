FROM ruby:2.3-slim
RUN apt-get -y update
RUN apt-get -y install build-essential

# mysql
RUN apt-get -y install libmysqlclient-dev

# postgres
RUN apt-get -y install libpq-dev

# sqlite
RUN apt-get -y install libsqlite3-dev

# mongodb
RUN apt-get -y install mongodb-clients

WORKDIR /opt/uphold
COPY Gemfile /opt/uphold/Gemfile
COPY Gemfile.lock /opt/uphold/Gemfile.lock
RUN bundle install
ADD .

# this to just check the docker mounts works in development
RUN rm -rf dev

ENTRYPOINT ["ruby", "environment.rb"]
