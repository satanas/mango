require 'rake'
require 'active_record/fixtures'

namespace :doc do
  namespace :diagrams do
    desc 'Generate models diagrams'
    task :models do
      sh "railroad -i -l -a -m -M | dot -Tpng | sed 's/font-size:14.00/font-size:11.00/g' > doc/models.png"
    end

    desc 'Generate controllers diagrams'
    task :controllers do
      sh "railroad -i -l -C | neato -Tpng | sed 's/font-size:14.00/font-size:11.00/g' > doc/controllers.png"
    end
  end
end

namespace :db do
  namespace :fixtures do
    desc 'Load test user'
    task :users => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('users')
      run_fixture('clients')
    end

    desc 'Load test ingredients'
    task :ingredients => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('ingredients')
    end

    desc 'Load test products'
    task :products => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('products')
    end

    desc 'Load test schedule'
    task :schedules => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('schedules')
    end

    desc 'Load test lots'
    task :lots => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('lots')
    end

    desc 'Load fixtures for warehouse types'
    task :warehouse_types => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('warehouses_types')
    end

    desc 'Load fixtures for base units'
    task :base_units => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('bases_units')
    end

    desc 'Load fixtures for transaction types'
    task :transaction_types => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('transaction_types')
    end

    desc 'Load test recipes'
    task :recipes => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      r = Recipe.new
      r.import('test/receta_brill_nueva.txt', true)
      puts 'Loaded test recipes'
    end

    desc 'Initialize order number'
    task :orders_numbers => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      run_fixture('orders_numbers')
    end
  end

  desc 'Clean ingredients and recipes related tables'
  task :clean_ingredients => :environment do
    puts 'Borrando tabla de ordenes...'
    Order.delete_all
    puts 'Borrando tabla ingredients_recipes...'
    IngredientRecipe.delete_all
    puts 'Borrando tabla hopper_ingredients...'
    HopperIngredient.delete_all
    puts 'Borrando tabla hoppers...'
    Hopper.delete_all
    puts 'Borrando tabla recipes...'
    Recipe.delete_all
    puts 'Borrando tabla de ingredientes...'
    Ingredient.delete_all
    puts 'Purgados ingredientes'
  end
end

namespace :sys do
  desc 'Initialize system at first time'
  task :init => :environment do
    RAILS_ENV = ENV['RAILS_ENV'] || 'development'
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:fixtures:users'].invoke
    Rake::Task['db:fixtures:schedules'].invoke
    Rake::Task['db:fixtures:warehouse_types'].invoke
    Rake::Task['db:fixtures:base_units'].invoke
    Rake::Task['db:fixtures:transaction_types'].invoke
    Rake::Task['db:fixtures:orders_numbers'].invoke
    if RAILS_ENV == 'development'
      Rake::Task['db:fixtures:products'].invoke
      #Rake::Task['db:fixtures:recipes'].invoke
      #Rake::Task['db:fixtures:lots'].invoke
    end
  end
end

def run_fixture(table)
  fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
  Fixtures.create_fixtures(fixtures_dir, table)
  puts "Loaded fixtures for #{table}"
end
