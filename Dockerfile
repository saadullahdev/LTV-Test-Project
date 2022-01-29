FROM ruby:2.6.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
    && apt-get install -y build-essential git mariadb-client libxml2-dev libxslt1-dev nodejs yarn webpack \
    && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

RUN rake webpacker:install
