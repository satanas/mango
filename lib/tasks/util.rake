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
      fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
      Fixtures.create_fixtures(fixtures_dir, 'users')
      Fixtures.create_fixtures(fixtures_dir, 'clients')
      puts 'Loaded test users'
    end

    desc 'Load test ingredients'
    task :ingredients => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
      Fixtures.create_fixtures(fixtures_dir, 'ingredients')
      puts 'Loaded test ingredients'
    end
    
    desc 'Load test products'
    task :products => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
      Fixtures.create_fixtures(fixtures_dir, 'products')
      puts 'Loaded test products'
    end
    
    desc 'Load test schedule'
    task :schedules => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
      Fixtures.create_fixtures(fixtures_dir, 'schedules')
      puts 'Loaded test schedules'
    end

    desc 'Load test lots'
    task :lots => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      fixtures_dir = File.join(File.dirname(__FILE__), "../../test/fixtures")
      Fixtures.create_fixtures(fixtures_dir, 'lots')
      puts 'Loaded test lots'
    end

    desc 'Load test recipes'
    task :recipes => :environment do
      RAILS_ENV = ENV['RAILS_ENV'] || 'development'
      r = Recipe.new
      r.import('test/receta_brill_nueva.txt', true)
      puts 'Loaded test recipes'
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
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:fixtures:users'].invoke
    Rake::Task['db:fixtures:schedules'].invoke
    Rake::Task['db:fixtures:products'].invoke
    Rake::Task['db:fixtures:recipes'].invoke
    Rake::Task['db:fixtures:lots'].invoke
  end
end
