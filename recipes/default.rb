##
## Cookbook:: Cookbook-Wireless
## Recipe:: default
##
## Copyright:: 2018, The Authors, All Rights Reserved.
#

require "ohai"

if node["platform"] == "debian"
    include_recipe "#{node[:general][:cookbook][:name]}::ubuntu"
elsif node["platform"] == "kali"
    include_recipe "#{node[:general][:cookbook][:name]}::kali"
end

if node[:general][:chipset][:driver] == "apt"
    execute "[*] apt update do" do
        command "apt-get update -y"
        ignore_failure true
        action :true
    end

    execute "[*] apt install realtek driver" do
        command "apt-get install #{node[:general][:chipset][:apt][:realtek][:package]}"
        ignore_failure true
        action :run
    end

elsif node[:general][:chipset][:driver] == "8814au"

    ## Install wireless adaptor chipset
    execute "[*] Downloading RealTek Driver" do
        cwd "#{node[:general][:directory]}"
        command "git clone -b #{node[:general][:chipset][:branch]} #{node[:general][:chipset][:location]}"
        user "#{node[:general][:user]}"
        group "#{node[:general][:group]}"
        ignore_failure true
        action :run
    end

    execute "[*] apt upgrade" do
        command "apt update -y"
        ignore_failure true
        action :run
    end

    node[:general][:chipset][:dependencies].each do |pkg|
        package "#{pkg}" do
            action :install
        end
    end

    execute "[*] Compiling chipset" do
        cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
        command "make"
        action :run
    end

    execute "[*] Install chipset" do
        cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
        command "make"
        action :run
    end

elsif node[:general][:chipset][:driver] == "8812au"

    ## Install wireless adaptor chipset
    execute "[*] Downloading RealTek Driver" do
        cwd "#{node[:general][:directory]}"
        command "git clone -b #{node[:general][:chipset][:branch]} #{node[:general][:chipset][:location]}"
        user "#{node[:general][:user]}"
        group "#{node[:general][:group]}"
        ignore_failure true
        action :run
    end

    execute "[*] apt upgrade" do
        command "apt update -y"
        ignore_failure true
        action :run
    end

    node[:general][:chipset][:dependencies].each do |pkg|
        package "#{pkg}" do
            action :install
        end
    end

    execute "[*] Compiling chipset" do
        cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
        command "make"
        action :run
    end

    execute "[*] Install chipset" do
        cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
        command "make"
        action :run
    end
end

## Install rogue toolkit
if node[:general][:tool][:rogue][:enable]
    execute "[*] Downloading rogue toolkit" do
        cwd "#{node[:general][:directory]}"
        command "git clone #{node[:general][:tool][:rogue][:location]}"
        action :run
    end
    
    execute "[*] Install rogue toolkit" do
        cwd "#{node[:general][:directory]}#{node[:general][:tool][:rogue][:directory]}"
        command "echo 'y' | python install.py"
        ignore_failure true
        action :run
    end
end


## Install wireless adaptor chipset
execute "[*] Downloading RealTek Driver" do
    cwd "#{node[:general][:directory]}"
    command "git clone -b #{node[:general][:chipset][:branch]} #{node[:general][:chipset][:location]}"
    action :run
end

node[:general][:chipset][:dependencies].each do |pkg|
    package "#{pkg}" do
        action :install
    end
end

execute "[*] Compiling chipset" do
    cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
    command "make"
    action :run
end

execute "[*] Install chipset" do
    cwd "#{node[:general][:directory]}#{node[:general][:chipset][:directory]}"
    command "make install"
    action :run
end


## Install aircrack-ng
if node[:general][:tool][:aircrack][:enable]
    node[:general][:tool][:aircrack][:dependencies].each do |pkg|
        package "#{pkg}" do
            action :install
        end
    end

    execute "[*] Downloading aircrack-ng" do
        cwd "#{node[:general][:directory]}"
        command "git clone #{node[:general][:tool][:aircrack][:location]}"
        action :run
    end

    execute "[*] Installing aircrack-ng" do
        cwd "#{node[:general][:directory]}#{node[:general][:tool][:aircrack][:directory]}"
        command "autoreconf -i; ./configure; make; make install; ldconfig"
        action :run
    end
end


## Install hcxtools
if node[:general][:tool][:hcxtools][:enable]
    node[:general][:tool][:hcxtools][:dependencies].each do |pkg|
        package "#{pkg}" do
            action :install
        end
    end

    execute "[*] Downloading hcxtools" do
        cwd "#{node[:general][:directory]}"
        command "git clone #{node[:general][:tool][:hcxtools][:location]}"
        action :run
    end

    execute "[*] Installing hcxtools" do
        cwd "#{node[:general][:directory]}#{node[:general][:tool][:hcxtools][:directory]}"
        command "make; make install"
        action :run
    end
end


## Install hcxdumptool
if node[:general][:tool][:hcxdumptool][:enable]
    execute "[*] Downloading hcxdumptool" do
        cwd "#{node[:general][:directory]}"
        command "git clone #{node[:general][:tool][:hcxdumptool][:location]}"
        action :run
    end

    execute "[*] Installing hcxdumptool" do
        cwd "#{node[:general][:directory]}#{node[:general][:tool][:hcxdumptool][:directory]}"
        command "make; make install"
        action :run
    end
end


## Install scapy
if node[:general][:tool][:scapy][:enable]
    execute "[*] Installing scapy" do
        command "pip install #{node[:general][:tool][:scapy][:package]}"
        action :run
    end
end
