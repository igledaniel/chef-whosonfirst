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

user node[:wof][:user][:name] do
  only_if { node[:wof][:user][:enabled] }
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
  not_if { File.exists?(node[:wof][:data][:did_download]) }
end

include_recipe 'java'

include_recipe 'elasticsearch'

unless File.exists?(node[:wof][:pg][:did_setup_db])
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

unless File.exists?(node[:wof][:pg][:did_index])
  template node[:wof][:config][:spatial] do
    source 'spatial.cfg.erb'
  end
  execute 'index postgresql' do
    command "#{node[:wof][:spatial][:script]} -s #{node[:wof][:data][:path]} -c #{node[:wof][:config][:spatial]} 2>&1 >>#{node[:wof][:log][:index_pg]}"
  end
  file node[:wof][:pg][:did_index] do
    action :touch
  end
end

unless File.exists?(node[:wof][:es][:did_index])
  execute 'index elasticsearch' do
    command "#{node[:wof][:search][:script]} -s #{node[:wof][:data][:path]} -b 2>&1 >>#{node[:wof][:log][:index_es]}"
  end
  file node[:wof][:es][:did_index] do
    action :touch
  end
end
