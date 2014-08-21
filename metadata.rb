name             "storm"
maintainer       "Colin Surprenant"
maintainer_email "colin.surprenant@gmail.com"
license          "MIT License"
description      "installs and configures Twitter Storm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

%w{
    debian
    ubuntu
}.each do |os|
  supports os
end

depends 'zookeeper'
