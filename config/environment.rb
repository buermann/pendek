# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Rails.logger = Lumberjack::Logger.new( Rails.root + "log" + "#{Rails.env}.log" )
