# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'whosonfirst'

  config.omnibus.chef_version = '11.12.8'
  config.berkshelf.enabled = true
  config.vm.box = 'ubuntu-14.04-opscode'
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'

  config.vm.provision 'chef_solo' do |chef|
  chef.json = {
    'apt' => {
      'compile_time_update' => true
    },
    'authorization' => {
      'sudo' => {
        'users' => ['vagrant'],
        'passwordless' => true
      }
    },
    'java' => {
      'install_flavor' => 'oracle',
      'jdk_version' => '7',
      'oracle' => {
        'accept_oracle_download_terms' => 'true'
      },
      'jdk' => {
        '7' => {
          'x86_64' => {
            'url' => 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz',
            'checksum' => '764f96c4b078b80adaa5983e75470ff2'
          }
        }
      }
    },
  }
  chef.run_list = [
    'recipe[sudo]',
    'recipe[ohai]',
    'recipe[apt]',
    'recipe[git]',
    'recipe[python]',
    'recipe[whosonfirst::setup]',
  ]
  end
end
