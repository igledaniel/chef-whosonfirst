include_recipe 'whosonfirst::setup_common'

git node[:wof][:tools][:path] do
  repository node[:wof][:tools][:repository]
  revision node[:wof][:tools][:revision]
end

directory node[:wof][:meta][:path]

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

unless ::File.exists?(node[:wof][:pg][:did_index])
  include_recipe 'whosonfirst::load_postgresql'
  file node[:wof][:pg][:did_index] do
    action :touch
  end
end

unless ::File.exists?(node[:wof][:es][:did_index])
  # ensure that elasticsearch service has started
  service 'elasticsearch' do
    action :start
  end
  include_recipe 'whosonfirst::load_elasticsearch'
  file node[:wof][:es][:did_index] do
    action :touch
  end
end

include_recipe 'whosonfirst::setup_spelunker'
include_recipe 'whosonfirst::deploy_spelunker'
