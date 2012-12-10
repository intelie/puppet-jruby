# == Class: jruby
#
# JRuby instalation
#
# === Parameters
#
# [*version*]
#   Jruby version
#
# === Variables
#
# [*jruby_home*]
#   Destination path
#
# [*url*]
#   Download url
#
# === Examples
#
#  class { 'jruby':
#    version => '1.7.0.preview1'
#  }
#
# === Authors
#
# Jorge Falcão <falcao@intelie.com.br>
#
# === Copyright
#
# Copyright 2012 Intelie
#


class jruby (
  $version = '1.7.1',
  $prefix = '/opt/jruby',
  $url = 'UNSET'
) {

  $jruby_home = $prefix
  $package = "jruby-bin-${version}.tar.gz"
  
  if $url == 'UNSET' {
    $real_url = "http://jruby.org.s3.amazonaws.com/downloads/${version}/${package}"
  } else {
    $real_url = $url
  }

  Exec { path => "/usr/bin:/bin:/usr/local/bin/" }

  exec { "download_jruby":
    command => "wget -O /tmp/${package} ${real_url}",
    unless  => "ls /opt | grep jruby-${version}",
  } -> exec { "unpack_jruby":
    command => "tar -zxf /tmp/${package} -C /opt",
    creates => "${jruby_home}-${version}"
  }

  file { $jruby_home:
    ensure  => link,
    target  => "${jruby_home}-${version}",
    require => Exec["unpack_jruby"],
  }

  Jruby_Bin{ jruby_home => $prefix }

  # add jruby binaries
  jruby_bin{"jgem": }
  jruby_bin{"jirb": }
  jruby_bin{"jruby": }
  jruby_bin{"jrubyc": }
}
