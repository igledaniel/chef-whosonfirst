%w(
  /var/wof/meta
  /var/wof/data
  /etc/wof
  /opt/wof
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
