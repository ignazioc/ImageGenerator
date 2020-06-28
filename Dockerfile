FROM ruby:2.6

RUN apt-get update -qq && apt-get install -y build-essential wget imagemagick

RUN mkdir -p /app

WORKDIR /app

COPY . ./

RUN bundle install

EXPOSE 80
CMD ["bundle", "exec", "rackup", "config.ru", "-p", "80", "-s", "thin", "-o", "0.0.0.0"]
