FROM ruby:3.1.2-slim

ENV BUNDLER_VERSION=2.5.3
ENV NODE_VERSION=18.18.2
ENV NODE_MAJOR=18
ENV RAILS_VERSION=7.0.7.2

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install -y nodejs make gcc && npm install -g yarn

RUN mkdir -p /var/app
COPY . /var/app
WORKDIR /var/app

RUN gem install rails -v $RAILS_VERSION
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle install
RUN yarn install

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]