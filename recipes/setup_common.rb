# common setup across whosonfirst instances

%w(apt git python).each do |r|
  include_recipe r
end

user node[:wof][:user][:name] do
  only_if { node[:wof][:user][:enabled] }
end

%w(
  /etc/wof
  /opt/wof
).each do |d|
  directory d do
    recursive true
  end
end

directory node[:wof][:log][:path] do
  recursive true
  owner node[:wof][:user][:name]
end

%w(libgeos-dev libpq-dev python-pip).each do |p|
  package p
end

include_recipe 'whosonfirst::setup_repos'
