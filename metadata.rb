name             'whosonfirst'
maintainer       'mapzen'
maintainer_email 'aaron@mapzen.com'
license          'All rights reserved'
description      'Installs/Configures wof data and spelunker locally'
long_description ''
version          '0.0.1'

supports 'ubuntu'

%w(
sudo
apt
ohai
git
python
postgresql
postgis
database
nginx
java
elasticsearch
).each do |x|
  depends x
end
