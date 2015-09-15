[:placetypes, :utils, :spatial, :search].each do |reposym|
  git node[:wof][reposym][:path] do
    repository node[:wof][reposym][:repository]
    revision node[:wof][reposym][:revision]
    notifies :run, "execute[setup.py install wof-#{reposym}]", :immediately
  end
  execute "setup.py install wof-#{reposym}" do
    action :nothing
    command 'python setup.py install'
    cwd node[:wof][reposym][:path]
  end
end
