# Resque.logger.level = Logger::DEBUG
#Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
#puts 'Redis url is .....' + ENV['REDIS_URL']
#Resque.redis = Rails.env.production? ? ENV['REDIS_URL'] : 'localhost:6379'
rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'
config_file = rails_root + '/config/resque.yml'

resque_config = YAML::load(ERB.new(IO.read(config_file)).result)
Resque.redis = Redis.new(url: resque_config[rails_env], thread_safe: true)

