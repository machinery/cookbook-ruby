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

node["ruby"]["users"].each do |u_config|

  u_config["versions"].each do |v_config|

    installation_path = File.join(u_config["prefix"], v_config["version"])
    major_version     = v_config["version"].match(/^([0-9]\.[0-9])/)[1]

    remote_file "/tmp/ruby-#{v_config["version"]}.tar.gz" do
      source "http://ftp.ruby-lang.org/pub/ruby/#{major_version}/" +
             "ruby-#{v_config["version"]}.tar.gz"

      not_if do
        File.exist?("/tmp/ruby-#{v_config["version"]}.tar.gz") ||
        File.exist?(File.join(installation_path, "bin/ruby"))
      end
    end

    bash "install Ruby #{v_config["version"]}" do
      user "root"
      cwd "/tmp"
      code <<-EOH
        tar -zxf ruby-#{v_config["version"]}.tar.gz
        cd ruby-#{v_config["version"]}
        ./configure --prefix=#{installation_path}
        make && make install
      EOH

      not_if { File.exist?(File.join(installation_path, "bin/ruby")) }
    end

    (v_config["gems"] || []).each do |g_config|
      gem_package g_config["gem"] do
        gem_binary File.join(installation_path, "bin/gem")
        version g_config["version"]
      end
    end
  end

  bash "update #{u_config["user"]} permissions" do
    user "root"
    code "chown -R #{u_config["user"]}:#{u_config["user"]} #{u_config["prefix"]}"
  end
end

