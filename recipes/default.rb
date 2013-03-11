include_recipe "apt"
include_recipe "build-essential"

%w[
  zlib1g-dev
  libyaml-dev
  libssl-dev
  libgdbm-dev
  libreadline-dev
  libncurses5-dev
  libffi-dev
].each { |pkg| package pkg }

node["ruby"]["users"].each do |config|

  config["versions"].each do |version|

    installation_path = File.join(config["prefix"], version)
    major_version     = version.match(/^([0-9]\.[0-9])/)[1]

    remote_file "/tmp/ruby-#{version}.tar.gz" do
      source "http://ftp.ruby-lang.org/pub/ruby/#{major_version}/" +
             "ruby-#{version}.tar.gz"

      not_if do
        File.exist?("/tmp/ruby-#{version}.tar.gz") ||
        File.exist?(File.join(installation_path, "bin/ruby"))
      end
    end

    bash "install Ruby #{version}" do
      user "root"
      cwd "/tmp"
      code <<-EOH
        tar -zxf ruby-#{version}.tar.gz
        cd ruby-#{version}
        ./configure --prefix=#{installation_path}
        make && make install
        chown -R #{config["user"]}:#{config["user"]} #{config["prefix"]}
      EOH

      not_if { File.exist?(File.join(installation_path, "bin/ruby")) }
    end
  end
end

