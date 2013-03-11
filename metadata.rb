recipe "ruby", "Installs Ruby from source."

maintainer        "Michael van Rooijen"
maintainer_email  "meskyanichi@gmail.com"
license           "MIT"
description       "Installs Ruby from source."
long_description  File.read(File.expand_path("../README.md", __FILE__))
version           "0.0.1"
supports          "ubuntu"

depends "apt"
depends "build-essential"

