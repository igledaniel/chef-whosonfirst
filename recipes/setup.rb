user node[:wof][:user][:name] do
  only_if { node[:wof][:user][:enabled] }
end

%w(
  /var/wof/meta
  /var/wof/data
  /etc/wof
  /opt/wof
  /var/log/wof
).each do |d|
  directory d do
    recursive true
  end
end

directory '/var/run/wof' do
  owner node[:wof][:user][:name]
end

git node[:wof][:tools][:path] do
  repository node[:wof][:tools][:repository]
  revision node[:wof][:tools][:revision]
end

remote_file node[:wof][:meta][:csv] do
  action :create_if_missing
  source node[:wof][:meta][:url]
end

package 'libgeos-dev'

python_pip 'requests'

bash 'download wof microhood data' do
  code <<-EOH
    #{node[:wof][:tools][:path]}/scripts/download-meta.py \
      --source #{node[:wof][:data][:url]} \
      --dest #{node[:wof][:data][:path]} \
      #{node[:wof][:meta][:csv]}
    touch #{node[:wof][:data][:did_download]}
  EOH
  not_if { ::File.exists?(node[:wof][:data][:did_download]) }
end

include_recipe 'java'

include_recipe 'elasticsearch'

unless ::File.exists?(node[:wof][:pg][:did_setup_db])
  include_recipe 'whosonfirst::setup_postgresql'
  file node[:wof][:pg][:did_setup_db] do
    action :touch
  end
end

[:placetypes, :utils, :spatial, :search].each do |reposym|
  git node[:wof][reposym][:path] do
    repository node[:wof][reposym][:repository]
    revision node[:wof][reposym][:revision]
    notifies :run, "execute[setup.py install #{reposym}]", :immediately
  end
  execute "setup.py install #{reposym}" do
    action :nothing
    command 'python setup.py install'
    cwd node[:wof][reposym][:path]
  end
end

unless ::File.exists?(node[:wof][:pg][:did_index])
  template node[:wof][:cfg][:spatial] do
    source 'spatial.cfg.erb'
  end
  execute 'index postgresql' do
    command "#{node[:wof][:spatial][:script]} -s #{node[:wof][:data][:path]} -c #{node[:wof][:cfg][:spatial]} 2>&1 >>#{node[:wof][:log][:index_pg]}"
  end
  file node[:wof][:pg][:did_index] do
    action :touch
  end
end

unless ::File.exists?(node[:wof][:es][:did_index])
  # ensure that elasticsearch service has started
  service 'elasticsearch' do
    action :start
  end
  execute 'index elasticsearch' do
    command "#{node[:wof][:search][:script]} -s #{node[:wof][:data][:path]} -b 2>&1 >>#{node[:wof][:log][:index_es]}"
    # sometimes it takes a while for elasticsearch to start up the first time
    # these retries are meant to work around this case
    retries 3
    retry_delay 30
  end
  file node[:wof][:es][:did_index] do
    action :touch
  end
end

package 'gunicorn'
package 'python-gevent'

python_pip 'flask'

gunicorn_config node[:wof][:spelunker][:gunicorn][:cfg] do
  action :create
  listen "unix:#{node[:wof][:spelunker][:gunicorn][:socket]}"
  pid node[:wof][:spelunker][:gunicorn][:pid]
  worker_class node[:wof][:spelunker][:gunicorn][:worker_class]
  worker_processes node[:wof][:spelunker][:gunicorn][:worker_processes]
end

git node[:wof][:spelunker][:path] do
  repository node[:wof][:spelunker][:repository]
  revision node[:wof][:spelunker][:revision]
  notifies :restart, 'runit_service[spelunker]', :delayed
end

include_recipe 'runit'

runit_service 'spelunker' do
  action [:enable, :start]
  log true
  default_logger true
  sv_timeout node[:wof][:spelunker][:runit][:svwait]
end

include_recipe 'nginx'
nginx_web_app 'spelunker' do
  template 'spelunker-nginx.erb'
  application domains: ['spelunker'], ssl_support: false
end
