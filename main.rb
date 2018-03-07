require 'active_record'
require 'colorize'
require 'date'
require 'mechanize'
require 'net/http'
require 'open-uri'
require 'pg'

# Require models
require_relative 'models/bilan'
require_relative 'models/pcl'
require_relative 'models/modification'
require_relative 'models/radiation'
require_relative 'models/immatriculation'

# Require modules
require_relative 'modules/bilan'
require_relative 'modules/pcl'
require_relative 'modules/modification'
require_relative 'modules/radiation'
require_relative 'modules/immatriculation'
require_relative 'modules/scraper'

# Require services
require_relative 'services/downloader'
require_relative 'services/archives'
require_relative 'services/actual'

# Establishing connection
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Execute the scraper
Scraper.execute
