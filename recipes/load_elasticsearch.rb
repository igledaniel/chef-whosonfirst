[:data, :venue].each do |reposym|
  execute "index elasticsearch #{reposym}" do
    command "#{node[:wof][:search][:script]} -s #{node[:wof][reposym][:path]} -b 2>&1 >>#{node[:wof][:log][:index_es]}"
    only_if { node[:wof][reposym][:enabled]  }
    # sometimes it takes a while for elasticsearch to start up the first time when running in vagrant
    # these retries are meant to work around this case
    retries 3
    retry_delay 30
    timeout node[:wof][:load][:timeout]
  end
end
