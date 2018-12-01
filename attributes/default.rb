default['chef_client_updater']['channel'] = 'stable'
default['chef_client_updater']['prevent_downgrade'] = false
default['chef_client_updater']['post_install_action'] = Chef::Config[:no_fork] ? 'exec' : 'kill'
default['chef_client_updater']['chef_install_path'] = nil
default['chef_client_updater']['upgrade_delay'] = nil
default['chef_client_updater']['product_name'] = nil
default['chef_client_updater']['version_request'] = nil # nil=latest, can approximate like '13' or '12.2', fails if invalid
default['chef_client_updater']['artifactory_base_path'] = 'https://artifactory.example.com/artifactory/'
default['chef_client_updater']['omnitruck_repo'] = 'chef_omnitruck'
default['chef_client_updater']['packages_repo'] = 'chef_packages'
