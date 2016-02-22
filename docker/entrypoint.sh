#!/bin/sh

cd $APP_HOME
rm -rf tmp/pids/server.pid
bin/rails s -e $RAILS_ENV $@