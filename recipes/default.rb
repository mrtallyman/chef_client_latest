#
# Cookbook:: chef_client_latest
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
artifactory_base_path = node['chef_client_updater']['artifactory_base_path']
omnitruck_repo = node['chef_client_updater']['omnitruck_repo']
packages_repo = node['chef_client_updater']['packages_repo']
metadata_script = '/usr/local/bin/chef_metadata.rb'
metadata_file = '/var/chef/updater_metadata.txt'

ruby_chefdk_embedded_path = "/opt/chefdk/embedded/bin/"
ruby_chef_embedded_path = "/opt/chef/embedded/bin/"
ENV['PATH'] = "#{ENV['PATH']}:" + ruby_chefdk_embedded_path + ":" + ruby_chef_embedded_path

cookbook_file metadata_script do
  source 'chef_metadata.rb'
  mode '0500'
  action :nothing
end.run_action(:create)

ruby_block 'parse_metadata' do
  block do
    #tricky way to load this Chef::Mixin::ShellOut utilities
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    version_request = 'latest'
    unless node['chef_client_updater']['version_request'].nil?
      if /^(\d+\.)*\d?$/.match(node['chef_client_updater']['version_request'].to_s)
        version_request = node['chef_client_updater']['version_request']
      end
    end
    get_metadata = "curl '" + artifactory_base_path + omnitruck_repo + "/stable/chef/metadata?p=#{node['platform']}&pv=#{node['platform_version']}&m=#{node['kernel']['machine']}&v=" + version_request + "' > " + metadata_file
    get_metadata_out = shell_out(get_metadata).stdout
    get_version = metadata_script + ' version'
    get_sha256 = metadata_script + ' sha256'
    get_url = metadata_script + ' url'
    get_version_out = shell_out(get_version).stdout
    get_sha256_out = shell_out(get_sha256).stdout
    get_url_out = shell_out(get_url).stdout
    if (get_version_out.empty? or get_sha256_out.empty? or get_url_out.empty?) # this is a bad failure
      Chef::Log.warn '*** unable to get metadata, can not update chef-client ***'
    else
      node.normal['chef_client_updater']['version'] = get_version_out
      node.normal['chef_client_updater']['checksum'] = get_sha256_out
      get_url_out = get_url_out.gsub(/https\:\/\/packages\.chef\.io/, artifactory_base_path + packages_repo)
      node.normal['chef_client_updater']['download_url_override'] = get_url_out
    end
  end
  action :nothing
end.run_action(:run)

include_recipe 'chef_client_updater::default'
