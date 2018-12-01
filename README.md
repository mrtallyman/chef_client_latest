# chef_client_latest

This cookbook presumes that Artifactory is being used with remote repos for packages.chef.io, omnitruck.chef.io, and rubygems.org. Attributes can change the chef repo targets; rubygems_url must be set in client.rb or run chef_client wrapper to set.

Objective: keep chef-client updated or pinned with fuzzy logic for what constitutes "current".
