template node[:wof][:cfg][:spatial] do
  source 'spatial.cfg.erb'
end

[:data, :venue].each do |reposym|
  execute "index postgresql #{reposym}" do
    command "#{node[:wof][:spatial][:script]} -s #{node[:wof][reposym][:path]} -c #{node[:wof][:cfg][:spatial]} 2>&1 >>#{node[:wof][:log][:index_pg]}"
    only_if { node[:wof][reposym][:enabled] }
  end
end
