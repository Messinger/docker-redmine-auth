workers 2
tag "DockerRedmineAuth"

bind 'tcp://[::]:3000'

plugin 'tmp_restart'
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
activate_control_app 'unix://./tmp/pumactl.sock'

