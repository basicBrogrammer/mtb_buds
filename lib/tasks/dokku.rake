# frozen_string_literal: true

def config_string_to_h(str)
  str.split("\n").map do |config_str|
    config_str.split(/:(.+)/).map(&:strip) if config_str.include?(':')
  end.compact.to_h.with_indifferent_access
end

namespace :dokku do
  task :set do
    options = { :environment => 'production', 'path' => 'config/application.yml' }
    local_env = Figaro::Application.new(options).configuration

    dokku_config = config_string_to_h `dokku config`

    envs_to_set = []
    local_env.each do |key, value|
      dokku_value = dokku_config[key]
      next unless value != dokku_value

      answer = CLI::UI.ask(
        "Key: #{key}; Local value: #{value}; Dokku value: #{dokku_config[key]}",
        options: %w[yes no]
      )
      envs_to_set << key if answer == 'yes'
    end

    set_str = envs_to_set.map { |key| "#{key}=\"#{local_env[key]}\"".gsub(' ', '\ ') }.join(' ')
    # puts "The set str is : #{set_str}"
    `dokku config:set #{set_str}`
  end
end
