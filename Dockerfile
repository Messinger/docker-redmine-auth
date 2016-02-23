FROM ruby:alpine
MAINTAINER Rajko Albrecht
ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata sqlite-dev yaml-dev libstdc++  linux-headers" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-json yaml nodejs sqlite-libs bash"
ENV APP_HOME=/srv/docker-redmine-auth \
    RAILS_ENV=production

WORKDIR $APP_HOME


RUN apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
    gem install --no-document bundler && \
    echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    bundle config --global build.nokogiri  "--use-system-libraries" && \
    bundle config --global build.nokogumbo "--use-system-libraries" && \
    find / -type f -iname \*.apk-new -delete && \
    rm -rf /var/cache/apk/*
    rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
    rm -rf ~/.gem

COPY . $APP_HOME

RUN bundle install --no-cache && rake db:migrate &&\
    apk --update --upgrade del $BUILD_PACKAGES &&\


EXPOSE 3000

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
