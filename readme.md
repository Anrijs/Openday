##Requirements
* Rails 4
* Redis server

##Set up
 1. Use `git clone` to download code
 2. Configure application:
     - App: *config/config.yml*
    - Database: *config/database.yml*
    - Email: *config/initializers/pony.rb*
    - Admin: *db/seeds.rb*
 3. Prepare application:
    - `bundle install`
    - `rake db:setup`
    - `rake db:migrate`

## Starting application
 1. Start redis server `redis-server`
 2. Start sidekiq `bundle exec sidekiq`
 3. Start rails application `rails s`
 
## Registration managment
 1. Log in to admin panel: http://example.com/opendays
 2. Add faculties and programmes: http://example.com/faculties
 3. Add and set up openday: http://example.com/opendays
 4. View and compare opendays: http://example.com/opendays
