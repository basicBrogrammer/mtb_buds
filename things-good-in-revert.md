-[] rm .rubocop.yml (maybe reset rubocop)
- bundle outdated
  -[] pg gem 1.0
  -[] commentout capistrano gems
  -[] capybarar 2.13 -> 3.0

Procfile.dev
web: bundle exec rails s -b 0.0.0.0
# worker: env TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
# cron: bundle exec rake resque:scheduler
frontend: ./bin/webpack-dev-server
mailcatcher: ruby -rbundler/setup -e "Bundler.clean_exec('mailcatcher', '--foreground')"
