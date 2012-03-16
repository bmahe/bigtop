define ganglia::gmond ($cluster, $mcast_address = "239.2.11.71") {
  package { "ganglia-gmond":
    ensure => installed,
  }

  file {
    "/etc/gmond.conf":
      content => template('ganglia/gmond.conf'),
  }

  service { "gmond":
    ensure => running,
    subscribe => File["/etc/gmond.conf"],
    require => Package["ganglia-gmond"],
  }
}

class ganglia::gmetad {

  include apache

  package { "ganglia-gmetad":
    ensure => installed,
  }

  package { "ganglia-web":
    ensure => installed,
    notify => Service["httpd"],
  }

  file {
    "/etc/gmetad.conf":
        source => "file://puppet/ganglia/gmetad.conf",
  }

  service { "gmetad":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    subscribe => File["/etc/gmetad.conf"],
    require => Package["ganglia-gmetad"],
  }

}

