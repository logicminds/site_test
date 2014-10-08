require 'spec_helper'

describe 'site_test' do
  let(:facts) do
    {}
  end

  describe 'computer1.mycompany.com' do
    let(:node) do
      'computer1.mycompany.com'
    end

    it {should contain_notify('computer1') }
  end

  describe 'computer2.mycompany.com' do
    let(:node) do
      'computer2.mycompany.com'
    end

    it {should contain_notify('computer2') }
  end

  describe 'computer3-6' do

    hosts = ['computer3.mycompany.com', 'computer4.mycompany.com','computer5.mycompany.com','computer6.mycompany.com']
    hosts.each do |host|
      describe host do
        let(:node) do
          host
        end
        it {should contain_notify('computer3-6') }
      end
    end
  end


  describe 'archer.isis.gov' do
    let(:node) do
      'archer.isis.gov'
    end

    it {should contain_notify('default') }
  end
end
