#node 'ip-172-31-19-148.eu-west-3.compute.internal' {

node default {

  file { '/tmp/puppet-test.txt':
    ensure => 'present',
    content => "bla bla bla",
    mode => "0644",
  }

  package { 'apache2':
    ensure => 'present',
  }

  service { 'apache2':
    ensure => 'running',
    enable => true,
    require => Package['apache2'],
  }


# Say /etc/puppetlabs/puppet/fileserver.conf contains:
# [testmount]
# path /tmp/mountpoint
# allow *
#
# and a file named 'mounted' is in /tmp/mountpoint.


  file {'/tmp/puppet-test2.txt':
    ensure => 'present',
    source => "puppet:///testmount/mounted",
    mode => "0666",
  }

  package { 'jq':
    ensure => 'present',
  }



}

#######################################################################################################
  $cname = $trusted[certname]
  $node_def_header = join(['node \'', $cname,"\' {\n"],'')

  $pack1 = "  package { 'tree':"
  $pack2 = "    ensure => present"
  $pack3 = "  }"

  $package_tree = join([$pack1,$pack2,$pack3,"\n"],"\n")

  $cont = join([$node_def_header,$package_tree,"}\n"],"\n")

  file { '/etc/puppetlabs/code/environments/production/manifests/site.d/master.pp':
    ensure => present,
    content => "${cont}",
  }

