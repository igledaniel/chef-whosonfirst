include_recipe 'whosonfirst::setup_common'

[:data, :venue].each do |reposym|
  git node[:wof][reposym][:path] do
    repository node[:wof][reposym][:repository]
    revision node[:wof][reposym][:revision]
    only_if { node[:wof][reposym][:enabled] }
  end
end
