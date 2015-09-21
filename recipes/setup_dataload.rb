include_recipe 'whosonfirst::setup_common'

[:data, :venue].each do |reposym|
  git node[:wof][reposym][:path] do
    repository node[:wof][reposym][:repository]
    revision node[:wof][reposym][:revision]
    only_if { node[:wof][reposym][:enabled] }
    timeout node[:wof][reposym][:timeout]
  end
end

directory node[:wof][:dataload][:dir] do
  recursive true
end

template node[:wof][:cfg][:spatial] do
  source 'spatial.cfg.erb'
end

template node[:wof][:dataload][:pg][:path] do
  source 'load-postgresql.sh.erb'
  mode '0755'
end

template node[:wof][:dataload][:es][:path] do
  source 'load-elasticsearch.sh.erb'
  mode '0755'
end
