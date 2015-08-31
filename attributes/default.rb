default[:elasticsearch][:version] = '1.3.3'

default[:wof][:user][:name] = 'wof'
default[:wof][:user][:enabled] = true

default[:wof][:tools][:path] = '/opt/wof/tools'
default[:wof][:tools][:repository] = 'https://github.com/whosonfirst/whosonfirst-tools.git'
default[:wof][:tools][:revision] = 'master'

default[:wof][:meta][:csv] = '/var/wof/meta/wof-microhood-latest.csv'
default[:wof][:meta][:url] = 'https://raw.githubusercontent.com/whosonfirst/whosonfirst-data/master/meta/wof-microhood-latest.csv'

default[:wof][:data][:url] = 'http://whosonfirst.mapzen.com/data'
default[:wof][:data][:path] = '/var/wof/data'
default[:wof][:data][:did_download] = '/var/wof/did-download-data'

default[:postgresql][:password][:postgres] = 'postgres'
default[:wof][:pg][:user] = 'wof'
default[:wof][:pg][:password] = 'wof'
default[:wof][:pg][:dbname] = 'wof'
default[:wof][:pg][:did_setup_db] = '/var/wof/did-setup-postgresql'
default[:wof][:pg][:conn_info] = {
  :host => "127.0.0.1",
  :port => 5432,
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}
