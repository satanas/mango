# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Porcinas::Application.initialize!

require 'pdf/writer'
require 'pdf/simpletable'
require 'easy_report'
