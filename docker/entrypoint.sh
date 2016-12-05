#!/bin/sh

#cd $APP_HOME
rm -rf tmp/pids/server.pid
#bundle exec unicorn -E production -p 3000 -c ./config/unicorn.rb $@
passenger start -p 3000 -e production --log-file /dev/stdout
