require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
RSpec.configure do |c|
  c.formatter = 'documentation'
  #c.module_path = File.expand_path(File.join(__FILE__, '..', '..', 'modules'))   # defaults to this module
  #c.manifest = File.expand_path(File.join(__FILE__, '..', '..', 'site.pp'))
  c.deprecation_stream = File.open('out.txt', 'w')
end
#at_exit { RSpec::Puppet::Coverage.report! }
