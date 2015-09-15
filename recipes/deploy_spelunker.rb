# include to ensure that repos get synced on deploy
# and runit can subscribe to them
include_recipe 'whosonfirst::setup_repos'

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
  subscribes :restart, 'execute[setup.py install wof-placetypes]', :delayed
  subscribes :restart, 'execute[setup.py install wof-utils]', :delayed
  subscribes :restart, 'execute[setup.py install wof-spatial]', :delayed
  subscribes :restart, 'execute[setup.py install wof-search]', :delayed
end
