# Resque.logger.level = Logger::DEBUG
#Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.redis = Rails.env.production? ? ENV['REDIS_URL'] : 'localhost:6379'
