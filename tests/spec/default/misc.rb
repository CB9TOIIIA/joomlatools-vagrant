require 'spec_helper'

describe '## Miscellaneous' do

    describe '### CloudCommander' do
        describe service('cloudcommander'), :if => os[:family] == 'ubuntu' do
          it { should be_enabled }
          it { should be_running }
        end

        describe port(8001) do
          it { should be_listening }
        end

        describe command('npm -g list cloudcmd') do
          its(:exit_status) { should eq 0}
        end

        describe file('/etc/apache2/conf-available/joomla.box.conf') do
          it { should exist }
          its(:content) { should match /Redirect permanent \/filebrowser http:\/\/joomla.box:8001\/fs\/var\/www/ }
        end
     end

    describe '### Wetty' do
        describe service('wetty'), :if => os[:family] == 'ubuntu' do
          it { should be_enabled }
          it { should be_running }
        end

        describe port(3000) do
          it { should be_listening }
        end

        describe command('npm -g list wetty') do
          its(:exit_status) { should eq 0}
        end

        describe file('/etc/apache2/conf-available/joomla.box.conf') do
          its(:content) { should match /Redirect permanent \/terminal http:\/\/joomla.box:3000/ }
        end
     end

     describe '### PimpMyLog' do
        describe file('/etc/apache2/conf-available/joomla.box.conf') do
          its(:content) { should match /Alias \/pimpmylog \/usr\/share\/pimpmylog\// }
        end

        describe file("/usr/share/pimpmylog/index.php") do
            it { should exist }
            its(:content) { should match /pimpmylog/ }
        end

        ['apache2', 'mysql', 'syslog'].each do |conf|
            describe file("/usr/share/pimpmylog/config.user.d/#{conf}.json") do
                it { should exist }
            end
        end

        ['/var/log/syslog'].each do |log|
            describe file(log) do
              it { should be_mode 644 }
            end
        end
     end

end