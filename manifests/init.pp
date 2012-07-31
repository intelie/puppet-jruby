# == Class: jruby
#
# JRuby instalation
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { jruby:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
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
class jruby {
  $jruby_home = "/opt/jruby"
  $version = "1.7.0.preview1"

  $url = "http://jruby.org.s3.amazonaws.com/downloads/${version}/jruby-bin-${version}.tar.gz"

  exec { "download_jruby":
    command     => "wget -O /tmp/jruby.tar.gz ${url}",
    path        => $path,
    unless      => "ls /opt | grep jruby-${version}",
  }

  exec { "unpack_jruby":
    command => "tar -zxf /tmp/jruby.tar.gz -C /opt",
    path    => $path,
    creates => "${jruby_home}-${version}",
    require => Exec["download_jruby"]
  }

  file { $jruby_home:
    ensure  => link,
    target  => "${jruby_home}-${version}",
    require => Exec["unpack_jruby"],
  }
  
  # TODO: bin/jruby options

}
