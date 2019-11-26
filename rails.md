# Setup
## Rails Generator and Directory system

Rails Generator Source Code: https://github.com/rails/rails/blob/master/railties/lib/rails/generators/app_base.rb

`initializers directory` will run before application sets up, eg: if you wanted to connect to the Google Maps API

`application.rb` controls everything, like a master file

`lib directory` custom rake tasks, custom algorithms etc


## Generators

`rails g controller Pages home about index` will generate the routes, pages, and a pages_controller with those three methods and pages

`rails g scaffold Page name:string` will generate a new model, database table, views and controller, and fill in all CRUD functions
`rails g model Page name:string` will just generate a new model and database table
`rails g resource Pages name:string` will create model, database table, empty controller, and empty views

`rails g migration <AddColumnNameToTableName> columnName:datatype`
`rails g migration <RemoveColumnNameFromTableName> columnName:datatype`

## Customise application.rb
```
// application.rb

module AppName
  class Application < Rails::Application

    # Default generators, default to uuids
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework :rspec
      g.template_engine :erb
      g.stylesheets false
      g.javascripts false
    end

    # Allows CORS requests
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :methods => [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    # Set default timezone
    config.timezone = 'UTC'
  end
end
```

# Coding in Rails
Use `before_action` to set current model for each controller method from params

```
class BlogsController > ApplicationController
  before_action :set_blog, only: [:show]

  def show
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end
end
```

`redirect_to @blog` will redirect to @blog's `show` page, or `blog_path(@blog)`


