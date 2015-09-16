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

default[:wof][:meta][:path] = '/var/wof/meta'
default[:wof][:meta][:csv] = '/var/wof/meta/wof-microhood-latest.csv'
default[:wof][:meta][:url] = 'https://raw.githubusercontent.com/whosonfirst/whosonfirst-data/master/meta/wof-microhood-latest.csv'

default[:wof][:data][:path] = '/var/wof/data'
default[:wof][:data][:repository] = 'https://github.com/whosonfirst/whosonfirst-data.git'
default[:wof][:data][:revision] = 'master'
default[:wof][:data][:enabled] = false
# in vagrant run, only download a subset of the data
default[:wof][:data][:url] = 'http://whosonfirst.mapzen.com/data'
default[:wof][:data][:did_download] = '/var/wof/did-download-data'

default[:wof][:venue][:path] = '/var/wof/data'
default[:wof][:venue][:repository] = 'https://github.com/whosonfirst/whosonfirst-venue.git'
default[:wof][:venue][:revision] = 'master'
default[:wof][:venue][:enabled] = false

default[:wof][:dataload][:dir] = '/opt/wof/bin'
default[:wof][:dataload][:pg][:path] = '/opt/wof/bin/load-postgresql.sh'
default[:wof][:dataload][:es][:path] = '/opt/wof/bin/load-elasticsearch.sh'

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
# control creating the user and database
# if managed separately, set to false
# setting up the database table itself will still occur
default[:wof][:pg][:setup_user_db][:enabled] = true

default[:elasticsearch][:version] = '1.7.1'
default[:wof][:es][:did_index] = '/var/wof/did-index-elasticsearch'

default[:wof][:cfg][:spatial] = '/etc/wof/spatial.cfg'

default[:wof][:log][:path] = '/var/log/wof'
default[:wof][:log][:index_pg] = '/var/log/wof/index-postgresql.log'
default[:wof][:log][:index_es] = '/var/log/wof/index-elasticsearch.log'

default[:wof][:spelunker][:path] = '/opt/wof/spelunker'
default[:wof][:spelunker][:repository] = 'https://github.com/whosonfirst/whosonfirst-www-spelunker.git'
default[:wof][:spelunker][:revision] = 'master'
default[:wof][:spelunker][:spatial_dsn] = "dbname=#{node[:wof][:pg][:dbname]} user=#{node[:wof][:pg][:user]} password=#{node[:wof][:pg][:password]} host=#{node[:wof][:pg][:host]}"
default[:wof][:spelunker][:es][:host] = 'localhost'
default[:wof][:spelunker][:es][:port] = node[:elasticsearch][:http][:port]
default[:wof][:spelunker][:runit][:svwait] = 10
default[:wof][:spelunker][:gunicorn][:access_log_format] = '"%(r)s" %(s)s %(b)s "%(a)s" %(l)s %(T)s'
default[:wof][:spelunker][:gunicorn][:cfg] = '/etc/wof/gunicorn.cfg'
default[:wof][:spelunker][:gunicorn][:pid] = '/var/run/wof/spelunker.pid'
default[:wof][:spelunker][:gunicorn][:socket][:dir] = '/var/run/wof'
default[:wof][:spelunker][:gunicorn][:socket][:path] = '/var/run/wof/spelunker.socket'
default[:wof][:spelunker][:gunicorn][:worker_class] = 'gevent'
default[:wof][:spelunker][:gunicorn][:worker_processes] = node[:cpu][:total] * 2 + 1
default[:wof][:spelunker][:gunicorn][:cwd] = "#{node[:wof][:spelunker][:path]}/www"
default[:wof][:spelunker][:gunicorn][:app_module] = 'server:app'
default[:wof][:spelunker][:static_path] = "#{node[:wof][:spelunker][:path]}/www"

default[:wof][:spelunker][:nginx][:port] = 8080
default[:wof][:spelunker][:nginx][:script_name] = ''
