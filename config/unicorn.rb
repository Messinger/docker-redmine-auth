# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

rails_env = ENV['RAILS_ENV'] || 'production'

timeout (rails_env == 'production' ? 15 : 1500)
preload_app (rails_env == 'production' ? true : false)

listen 3000
listen '[::]:3000', :ipv6only => true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
