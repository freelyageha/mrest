# config valid only for Capistrano 3.1
#lock '3.2.1'
lock '3.4.0'

set :application, 'mrest'
set :repo_url, 'git@github.com:freelyageha/mrest.git'

# Default branch is :master
set :branch, fetch(:branch, "master")
set :env, fetch(:env, "production")

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/action/dist/mrest/#{fetch(:stage)}"

# set temp dir
set :tmp_dir, "/home/action/tmp/#{fetch(:stage)}"

set :rvm_type, :system    # :user is the default

# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{public/picture/ssyls}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :check do
  task :variable do
    puts "#{fetch(:stage)}"
  end
end

namespace :deploy do
  desc "restart rack apps"
  task :restart_rails do
    on roles(:web) do |host|
      begin
        execute "touch #{current_path}/tmp/restart.txt"
     rescue
     end
    end
  end

  desc "install gems"
  task :bundle do
    on roles(:web) do |host|
      execute "source /home/action/.bash_profile && cd #{current_path} && bundle install"
    end
  end

  _rake = "/home/action/.parts/opt/rubies/ruby-2.1.3/bin/rake"
  desc "precompile assets for static resources"
  task :asset_precompile do
    on roles(:web) do |host|
      execute "source /home/action/.bash_profile && cd #{current_path} && RAILS_ENV=#{fetch(:stage)} #{_rake} assets:precompile"
    end
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

  desc "migrate database"
  task :migrate_db do
    on roles(:web) do |host|
      execute "source /home/action/.bash_profile && cd #{current_path} && RAILS_ENV=#{fetch(:stage)} #{_rake} db:migrate"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
