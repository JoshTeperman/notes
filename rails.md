# Setup
## Rails Generator and Directory system

Rails Generator Source Code: https://github.com/rails/rails/blob/master/railties/lib/rails/generators/app_base.rb

`initializers directory` will run before application sets up, eg: if you wanted to connect to the Google Maps API

`application.rb` controls everything, like a master file

`lib directory` custom rake tasks, custom algorithms etc


## Generators

`rails g controller Pages home about index` will generate the routes, pages, and a pages_controller with those three methods and pages


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


