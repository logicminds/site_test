# Class: sample_class
#
#
class sample_class (
  String $var1 = $sample_class::params::var1,
  String $var2 = $sample_class::params::var2,
) inherits sample_class::params {{
  # resources
  file { '/some/location':
    ensure => 'present',
    source => 'puppet:///modules/modulename/sample-file.txt'
  }
}
