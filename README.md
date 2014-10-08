# How to unit test your site.pp file

### What is this?

This is a simple example module to show you how you can unit test your site.pp to ensure your node 
resources work as expected.  If your site.pp file fails to classify your nodes properly you might have a simple logic bug
if your classification code. This is easy to test!
Testing is accomplished by basically creating an empty module with unit tests and running your site.pp through the tests.
These tests are really simple as they only test to ensure a specific resource exists in the
catalog for that node. 


## Instructions

### Setup Your own module
1. git clone https://github.com/logicminds/site_test
2. cd site_test
3. Configure the rspec settings to point to your site.pp manifest file

#### Configure Rspec settings
If you are integrating this module into your own puppet repo you will want to tweak a few rspec settings.
Every environment will be different but this assumes you have a modules and manifests directory two levels up.
This module does not configure a custom modules and manifests path because rspec-puppet defaults to using the fixtures
directory where I have placed a example site.pp file.  But you will most likely need to perform this step.

You should tweak the c.module_path and c.manifest path.

Edit the spec/spec_helper.rb in the site-test module
```ruby
   RSpec.configure do |c|
     c.formatter = 'documentation'
     c.module_path = File.expand_path(File.join(__FILE__, '..', '..', 'modules'))   # defaults to this module
     c.manifest = File.expand_path(File.join(__FILE__, '..', '..', 'manifests', 'site.pp'))
   end

```

Or if your lazy just place your site.pp file in the spec/fixtures/manifests directory overwriting the current site.pp file.
Just place a comment in front or remove the two lines regarding module_path and manifest. 

### Writing some basic tests
[Take a moment to familiarize yourself with basic Puppet Unit testing](http://rspec-puppet.com)

Given the following node resource in site.pp we want to test to verify that the notify resource with name 'computer1'
exists in the catalog.  If this resource exists than your node was classified correctly.
To get started modify the site_test_spec.rb tests to match what you have in your site.pp.


Node resource from site.pp
```puppet
node 'computer1.mycompany.com' {
  notify{"computer1":}
}
```
 
Unit test that verifies the catalog contains the notify resource with name 'computer1'
```ruby
describe 'computer1.mycompany.com' do
    let(:node) do
      'computer1.mycompany.com'
    end

    it {should contain_notify('computer1') }
end 
```

Your not required to use notify resources in your tests but its the easiest to setup. Ideally you should test for all
the resources you have defined for that node resource. 


#### Example with roles/profiles:
If you are using the roles/profiles convention I highly recommend 
testing for the presence of your role.  You should only have one role assigned per node so the test should be really easy.  
You might be tempted to test for the presence of the profile(s) and other classes that are included
in the roles::apache class.  
However, your site_test should only test what is declared in the node resource which in this case is roles::apache.
If you want to test if the profiles are included you should test that specifically in your roles module.
You want to know when someone breaks your site.pp file and not the role classes so keep them separated.

Node resource from site.pp
```puppet
node 'computer1.mycompany.com' {
  include roles::apache
}
```
 
Unit test that verifies the catalog contains the class roles::apache
```ruby
describe 'computer1.mycompany.com' do
    let(:node) do
      'computer1.mycompany.com'
    end

    it {should contain_class('roles::apache') }
end 
```

Sometimes you will have complex regular expressions in your site.pp and no matter how much you test them in
rubular.com, puppet evaluates nodes in a paticular manner that might not be obvious.  Additionally, the syntax is 
just a tad different when it comes to regular expressions.  So its best to test your handy work.

```puppet
node /\w*[3-6]{1}\w*/ {
   include roles::puppetmaster
}
```
Unit test that verifies the catalog contains the class roles::puppetmaster for computers 3-6

```ruby
describe 'computer3-6' do
    hosts = ['computer3.mycompany.com', 'computer4.mycompany.com','computer5.mycompany.com','computer6.mycompany.com']
    hosts.each do |host|
      describe host do
        let(:node) do
          host
        end
        it {should contain_class('roles::puppetmaster') }
      end
    end
  end

```

#### Multiple Test Suites
For a more advanced setup, you can create multiple test suites by creating different files to test specific sets of hosts.
This can make it faster to debug by testing only a single test suite if you have many node resources.

example:  spec/classes/nonprod_spec.rb, spec/classes/production_spec.rb, spec/classes/uat_spec.rb

### Coupling with your pre-commit hook
If you have a pre-commit hook setup already, write a simple script that checks if site.pp is in the git change set
and run the site_test unit tests.  This will cause your pre-commit hook to fail if anything is broken in site.pp.
  

### Running this tests
1. gem install bundler if using ruby < 2.0
2. cd site_test
2. bundle install
3. rake spec   (runs unit tests)

### Rspec output for site.pp
```shell
   site_test
     computer1.mycompany.com
   .    should contain Notify[computer1]
     computer2.mycompany.com
   .    should contain Notify[computer2]
     computer3-6
       computer3.mycompany.com
   .      should contain Notify[computer3-6]
       computer4.mycompany.com
   .      should contain Notify[computer3-6]
       computer5.mycompany.com
   .      should contain Notify[computer3-6]
       computer6.mycompany.com
   .      should contain Notify[computer3-6]
     archer.isis.gov
   .    should contain Notify[default]

Finished in 0.21203 seconds (files took 0.81476 seconds to load)
7 examples, 0 failures

```


#### License
LGPLv2.1

#### Contact
Corey Osman

#### Support
Please use the github issue tracker if its related to this module.