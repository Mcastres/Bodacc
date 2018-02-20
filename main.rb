require 'active_record'
require 'colorize'
require 'date'
require 'mechanize'
require 'net/http'
require 'open-uri'
require 'pg' # or 'mysql2' or 'sqlite3'

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

# Establishing connection
ActiveRecord::Base.establish_connection(
  adapter:  'postgresql', # or 'mysql2' or 'sqlite3'
  database: 'bodacc',
  username: '',
  password: '',
  host:     'localhost',
)

Scrapper::ScraperAction.execute
