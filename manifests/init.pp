

class kibana (
  $webroot    = '/usr/share/kibana',
  $source_tar = 'https://github.com/elasticsearch/kibana/archive/master.tar.gz',
  $port       = '80'

) {

  exec { 'download-kibana':
    command => "/usr/bin/wget -O /var/tmp/kibana.tar.gz $source_tar",
    creates => '/var/tmp/kibana.tar.gz',
  }

  exec { 'extract-kibana':
    command => "/bin/tar xf /var/tmp/kibana.tar.gz -C $webroot",
    creates => "$webroot/index.html"
  }

  if !defined(Class['apache']) {
    class { 'apache': }
  }

  apache::vhost { $fqdn:
    port    => $port,
    docroot => $webroot,
  }

  Exec['download-kibana'] -> Exec['extract-kibana']

}

