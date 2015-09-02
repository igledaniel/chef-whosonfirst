default[:wof][:user][:name] = 'wof'
default[:wof][:user][:enabled] = true

default[:wof][:tools][:path] = '/opt/wof/tools'
default[:wof][:tools][:repository] = 'https://github.com/whosonfirst/whosonfirst-tools.git'
default[:wof][:tools][:revision] = 'master'

default[:wof][:placetypes][:path] = '/opt/wof/placetypes'
default[:wof][:placetypes][:repository] = 'https://github.com/whosonfirst/py-mapzen-whosonfirst-placetypes.git'
default[:wof][:placetypes][:revision] = 'master'

default[:wof][:utils][:path] = '/opt/wof/utils'
default[:wof][:utils][:repository] = 'https://github.com/whosonfirst/py-mapzen-whosonfirst-utils.git'
default[:wof][:utils][:revision] = 'master'

default[:wof][:spatial][:path] = '/opt/wof/spatial'
default[:wof][:spatial][:repository] = 'https://github.com/whosonfirst/py-mapzen-whosonfirst-spatial.git'
default[:wof][:spatial][:revision] = 'master'
default[:wof][:spatial][:script] = "#{node[:wof][:spatial][:path]}/scripts/wof-spatial-index"

default[:wof][:search][:path] = '/opt/wof/search'
default[:wof][:search][:repository] = 'https://github.com/whosonfirst/py-mapzen-whosonfirst-search.git'
default[:wof][:search][:revision] = 'master'
default[:wof][:search][:script] = "#{node[:wof][:search][:path]}/scripts/wof-es-index"

default[:wof][:meta][:csv] = '/var/wof/meta/wof-microhood-latest.csv'
default[:wof][:meta][:url] = 'https://raw.githubusercontent.com/whosonfirst/whosonfirst-data/master/meta/wof-microhood-latest.csv'

default[:wof][:data][:url] = 'http://whosonfirst.mapzen.com/data'
default[:wof][:data][:path] = '/var/wof/data'
default[:wof][:data][:did_download] = '/var/wof/did-download-data'

default[:postgresql][:password][:postgres] = 'postgres'
default[:wof][:pg][:user] = 'wof'
default[:wof][:pg][:password] = 'wof'
default[:wof][:pg][:dbname] = 'wof'
default[:wof][:pg][:host] = 'localhost'
default[:wof][:pg][:did_setup_db] = '/var/wof/did-setup-postgresql'
default[:wof][:pg][:did_index] = '/var/wof/did-index-postgresql'
default[:wof][:pg][:postgres_conn_info] = {
  :host => "127.0.0.1",
  :port => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}
default[:wof][:pg][:user_conn_info] = node[:wof][:pg][:postgres_conn_info].clone
default[:wof][:pg][:user_conn_info].update({
  :username => node[:wof][:pg][:user],
  :password => node[:wof][:pg][:password],
})

default[:elasticsearch][:version] = '1.3.3'
default[:wof][:es][:did_index] = '/var/wof/did-index-elasticsearch'

default[:wof][:config][:spatial] = '/etc/wof/spatial.cfg'

default[:wof][:log][:index_pg] = '/var/log/index-postgresql.log'
default[:wof][:log][:index_es] = '/var/log/index-elasticsearch.log'
