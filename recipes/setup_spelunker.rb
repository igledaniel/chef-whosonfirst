include_recipe 'whosonfirst::setup_common'

%w(gunicorn python-gevent).each do |p|
  package p
end

python_pip 'flask'

directory node[:wof][:spelunker][:gunicorn][:socket][:dir] do
  owner node[:wof][:user][:name]
end

gunicorn_config node[:wof][:spelunker][:gunicorn][:cfg] do
  action :create
  listen "unix:#{node[:wof][:spelunker][:gunicorn][:socket][:path]}"
  pid node[:wof][:spelunker][:gunicorn][:pid]
  worker_class node[:wof][:spelunker][:gunicorn][:worker_class]
  worker_processes node[:wof][:spelunker][:gunicorn][:worker_processes]
end

include_recipe 'nginx'
nginx_web_app 'spelunker' do
  template 'spelunker-nginx.erb'
  application domains: ['spelunker'], ssl_support: false
end
