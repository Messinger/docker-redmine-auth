#!/bin/sh

#cd $APP_HOME
rm -rf tmp/pids/puma.pid
bundle exec puma -e production
