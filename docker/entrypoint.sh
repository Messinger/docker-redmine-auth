#!/bin/sh

cd $APP_HOME
rm -rf tmp/pids/server.pid
bundle exec unicorn -p 3000 -c ./config/unicorn.rb $@
