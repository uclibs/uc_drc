# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'
set :application, 'UC DRC'
set :repo_url, 'https://github.com/uclibs/uc_drc.git'
set :keep_releases, 2

task :shared_db do
  on roles(:all) do
    execute "mkdir -p #{fetch(:deploy_to)}/shared/db/ && touch #{fetch(:deploy_to)}/shared/db/development.sqlite3"
    execute "cp #{fetch(:deploy_to)}/static/.env.development.local #{fetch(:release_path)}/ || true"
  end
end

task :start_curly do
  on roles(:all) do
    execute "export PATH=$PATH:/usr/sbin/ && cd #{fetch(:deploy_to)}/current/script && chmod u+x * && source start_curly.sh"
  end
end
