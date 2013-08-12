

class kibana (
  $kibana_directory  = '/usr/share/kibana',
  $kibana_source_tar = 'https://github.com/elasticsearch/kibana/archive/master.tar.gz'
) {

  exec { 'download-kibana':
    command => "/usr/bin/wget -O /var/tmp/kibana.tar.gz $kibana_source_tar",
    creates => '/var/tmp/kibana.tar.gz',
  }

  exec { 'extract-kibana':
    command => "tar xf /var/tmp/kibana.tar.gz -C /usr/share/kibana",
    creates => "$kibana_directory/index.html"
  }

  if !defined(Class['apache']) {
    class { 'apache':
      docroot => $kibana_directory,
    }
  }

  Exec['download-kibana'] -> Exec['extract-kibana']

}

