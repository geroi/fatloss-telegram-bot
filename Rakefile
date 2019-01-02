# Документация по rake docs.rubyrake.org/
# namespace -- rake.rubyforge.org/classes/Rake/NameSpace.html
require './lib/sqlite.rb'

task default: %w[test]

task :test do 
  puts Dir.pwd
  puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
end
namespace :db do
  desc "Delete the db"
  task :delete do
    File.delete "./db/records.sqlite"
  end
  desc "Reset db"
  task :reset => [:delete, :connect, :seed] do
    #
  end
  desc "Seed the database"
  task :seed do
    ruby "./misc/seeder.rb"
  end
  desc "Migrate the database"
  task :clean do
    ruby "./misc/clean.rb"
  end
  desc "Migrate the database"
  task :connect do
    ruby "./lib/sqlite.rb"
  end
  desc "Migrate the database"
  task :migrate do
    # выполнение всех миграций из ./db/migrate,
    # метод принимает параметры: migrate(migrations_path, target_version = nil)
    # в нашем случае
    # migrations_path = lib/db/migrate
    # target_version =  ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    # миграция запускается как rake db:migrate VERSION=номер_версии или без версии
    ActiveRecord::Migrator.migrate('./db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end