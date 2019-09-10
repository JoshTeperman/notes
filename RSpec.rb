# spec_helper.rb
require 'factory_bot'
  
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# /factories/user.rb
FactoryBot.define do
  factory :user do
    email { 'email@email.com' }
    password  { 'password' }
  end
end

# spec/users.rb
let(:test_user) { create(:user) }

it 'some test' do
  expect(test_user).to be_valid
end

it 'some other test' do
  new_user = create(:user)
  expect(new_user).to be_valid
end

# LET

# Some properties:

# It's shareable between multiple 'it' statements.
# It's lazily evaluated first time each test calls it (use let!(...) if you want eager evaluation)
# It's value is cached if called multiple times in same spec (but not between specs)

# Example:

let(:some_name) { SomeClass.some_expensive_method }

it { puts some_name.object_id; puts some_name.object_id }
# => 12345
# => 12345

it { puts some_name.object_id }
# => 67890

# Note that just using 'before' syntax is not equivalent because it's not lazily evaluated. One way where lazy evaluation comes in handy is when your 'let' statement depends on a variable (or another 'let' statement) you set later or in a nested context, e.g.:

let(:account) { user.account }

context "for regular user"
  let(:user) { users(:user) }
  
  it "should not have an admin"
    expect(account).to have_admin
  end
end

context "for admin user"
  let(:user) { users(:admin) }
  
  it "should have an admin"
    expect(account).to_not have_admin
  end
end

// RUN A SPECIFIC test
rspec ./spec/controllers/groups_controller_spec.rb:42 <- line of the matching test
OR use tags:

it "example I'm working now", :mytag => true do
end
rspec . --tag mytag 
# will only run the test with the key :mytag


TEST_COVERAGE

# Gemfile

group :test do
  gem 'simplecov', require: false
end

# .gitignore
coverage

# /spec_helper.rb
require 'simplecov'
SimpleCov.start 'rails'

...

SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
end

# then run ->
bundle exec rspec
open coverage/index.html 


# Rails Controller Testing

bundle add rails-controller-testing

assigns
# assigns allows you to access the instance variables that have been passed to your views.

class PostsController < ActionController::Base
  def index
    @posts = Post.all
  end
end

class PostControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_equal Post.all, assigns(:posts)
  end
end

render_template
it 'renders the index template' do
  get :index
  expect(response).to render_template("index")
end

assert_template
assert_template allows to you assert that certain templates have been rendered.

class PostControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'posts/index'
  end
end


# ~/.rspec
--require spec_helper
--format documentation
--color
--fail-fast
