load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

after "deploy:update_code", :copy_over_config_files

task :copy_over_config_files do
  run "for config_file in #{deploy_to}/#{shared_dir}/config/*; do ln -nfs $config_file #{release_path}/config/`basename $config_file`; done"
end
