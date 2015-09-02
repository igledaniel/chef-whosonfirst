# works around pg gem installation issue
apt_package "ruby1.9.1-dev" do
  action :nothing
end.run_action(:install)

%w(
  postgresql::ruby
  postgresql::client
  postgresql::server
  postgis
).each do |r|
  include_recipe r
end

postgresql_database_user node[:wof][:pg][:user] do
  connection node[:wof][:pg][:postgres_conn_info]
  password node[:wof][:pg][:password]
  action :create
end

postgresql_database node[:wof][:pg][:dbname] do
  connection node[:wof][:pg][:postgres_conn_info]
  owner node[:wof][:pg][:user]
  action :create
end

postgresql_database_user node[:wof][:pg][:user] do
  connection node[:wof][:pg][:postgres_conn_info]
  database_name node[:wof][:pg][:dbname]
  privileges [:all]
  action :grant
end

%w(postgis hstore postgis_topology).each do |extension|
  postgresql_database "install postgresql extension #{extension}" do
    connection node[:wof][:pg][:postgres_conn_info]
    database_name node[:wof][:pg][:dbname]
    action :query
    sql "CREATE EXTENSION #{extension};"
  end
end

postgresql_database 'set up whosonfirst database' do
  connection node[:wof][:pg][:user_conn_info]
  database_name node[:wof][:pg][:dbname]
  action :query
  sql <<-EOH
    CREATE TABLE whosonfirst (id BIGINT PRIMARY KEY, parent_id BIGINT, placetype VARCHAR, properties TEXT, geom GEOGRAPHY(MULTIPOLYGON, 4326), centroid GEOGRAPHY(POINT, 4326));
    CREATE INDEX by_geom ON whosonfirst USING GIST(geom);
    CREATE INDEX by_placetype ON whosonfirst (placetype);
    ANALYZE;
  EOH
end
