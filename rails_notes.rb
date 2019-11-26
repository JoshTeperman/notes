clone repo
git remote add origin git@github.com:JoshTeperman/rails-books.git

rails new appname --database=postgresql
brew services postgres start postgresql

next create database
rails db:create
=> should be able to run server and view welcome page at localhost:3000

next create a controller
rails generate controller books
*** be very careful to generate a PLURAL controller

next create index method for landing page in books_controller.rb:
def index
end

next make books index the default landing page for the app in config/routes.rb
root to: 'books#index'

next add a view for default view page, in app/views/books/index.html.erb:
<h1>My Books</h1>

next add Book Model
rails generate model Book title:string author:string publisher:string genre:string description:string

next run the new migration:
rails db:migrate

next add faker to the app
bundle add faker

if bundle install doesnt work:
delete ruby_version file
delete line in gemfile
delete gemlock file

next add to db/seeds.rb see data
Book.destroy_all
50.times do
  params = {}
  book = Book.new(params)
  book.save
end

====================================================================================================
RESOURCES / ROUTES:
====================================================================================================
checkout resources docs 'rubyonrails.org/routing.html#singular-resources'

example:
root 'books$index'
resources :books
devise_for :users

resources :authors
resources :reviews

resources :charges
resources :articles 

# creates routes automatically, as alternative to explicitly defining as:
get "/articles, to: articles#index", as: articles 
# get VERB at /articles end-point will call Controller#Action index from articles_controller.rb 
# as: articles > as "" is the rails routes.rb prefix_path, (typically specifies page)


====================================================================================================
// Font-Awesome //
====================================================================================================
https://github.com/FortAwesome/font-awesome-sass

rename application.css to application.scss

gem 'font-awesome-rails'
gem 'font-awesome-sass'

# add to application.scss :
@import "font-awesome-sprockets";
@import "font-awesome";

# <link> tag into your application.html.erb 
# OR #
# can import with gems (bootstrap 4? ) checkout Bianca Power guide for Bootstrap 4 

# Examples:
icon('fas', 'flag')
# => <i class="fas fa-flag"></i>
icon('far', 'address-book', class: 'strong')
# => <i class="far fa-address-book strong"></i>
icon('fab', 'font-awesome', 'Font Awesome', id: 'my-icon', class: 'strong')
# => <i id="my-icon" class="fab fa-font-awesome strong"></i> Font Awesome

====================================================================================================
// BOOTSTRAP //
====================================================================================================

Bootsrap
# https://gist.github.com/DeepNeuralAI/a8f1cef21ebce0d72b5c463ca10226fe
# https://github.com/leahgarrett/rails-01-restaurant/commit/861d89b8b53c4519f5fe981fb7a54e6cb8fb421a
# add to gemfile
gem 'jquery-rails' #for javascript animations
gem 'bootstrap'
... if necessary comment out gem 'duktape' which might be intefering with runtime

# > then bundle install

# > add js dependencies to app/assets/javascripts/application.js
//= require jquery3
//= require popper
//= require bootstrap


# rename 
application.css to application.scss
# add to application.scss:
@import "bootstrap";

delete require_tree and require_self

====================================================================================================
// FLASH NOTICES/ //
====================================================================================================
https://api.rubyonrails.org/classes/ActionDispatch/Flash.html
# also, adding close to flash notice - article on stack overflow
https://stackoverflow.com/questions/31846741/bootstrap-rails-adding-close-to-flash-notice


# In application.html.erb:
<% flash.each do |key, value| %>
  <%= value %>
<% end %

# Then create flash messages:
if @profile.save
  flash[:success] = "Profile saved"
  redirect_to profile_path(@profile)
else
  flash[:error] = 'Error'
  render :new
end


====================================================================================================
// Refactor using partial components //
====================================================================================================

_navigation
then use render plus the path /layouts/navigation to render that partial component in the html.erb file
eg:
<h2> Comments: </h2>
<%= render 'comments/form'  
=> will render the _form.html.erb file in views/comments/

====================================================================================================
// FORMS //
====================================================================================================
<label for="x"></lablel> # turns all of the text into a hitbox - easy clickability
<input type="text" name="" id="">
https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label

> Edit:
<form action="<%= challenge_path(@challenge) %>" method="POST">
  <input type="hidden" value="<%= form_authenticity_token %>" name="authenticity_token">
  <input type="hidden" name="_method" value="patch">
</form>

// Nested Model Notes (ie: models with 'belongs_to') //

# in controller:
def create
  @restaurant = Restaurant.find(params[:restaurant_id])
  @review = @restaurant.reviews.create(review_params) # <- created from within parent model
  redirect_to restaurant_path(@restaurant.id) # <- path takes argument
end

<li>
  <p><%= restaurant.title %> - <%= restaurant.food_type %> <%= link_to "show", restaurant_path(restaurant.id) %></p>
  # note link_to path again takes the parent_model_path(parent_odel.id) argument
  <p>Reviews: <%= restaurant.reviews.count %></p>
</li>

// Console //

Model.where(key: value).first <- find something in console

==============================================================================================================
// Aaron - Relationships //
==============================================================================================================

ERD first (Entity Relationship Diagram)
Primary_keys are always unique. Typically model_id will be the primary_key
Parent theoretically has no idea how many children it has. Only the child knows that it is connected to the parent.

> in podcasts.rb         > in episodes.rb

class Podcast            class Episode
  has_many :episodes        belongs_to
end                      end

@podcst = Podcst.create()
@podcast.episodes

@episode = Episode.create()
@episode.podcast

p1.episodes << ep.1
p1.episodes << ep.2
# you would typically state validate + parameters in the episode model
# validate (episode must include podcast_id)

// LINK TO //
# https://mixandgo.com/learn/how-to-use-link_to-in-rails

<%= link_to "Home", root_path %>
# => <a href="/">Home</a>

<%= link_to "Profile", user_path(@user) %>
# => <a href="/users/1">Profile</a>
# .... same as: 
<%= link_to "Profile", @user %>
# => <a href="/users/1">Profile</a>

<%= link_to 'View', challenge_path(challenge) %>
=> same as <a href="/challenges/<%= challenge.id %>">View</a>

<%= link_to 'Back', :back >


====================================================================================================
// MANY TO MANY RELATIONSHIPS // 
====================================================================================================
https://www.sitepoint.com/master-many-to-many-associations-with-activerecord/
https://github.com/anharathoi/books_app_demo/pull/1
https://russt.me/2018/06/many-to-many-user-interface-in-ruby-on-rails-5/
https://stackoverflow.com/questions/2799746/habtm-relationship-does-not-support-dependent-option #dependents => destroy not supported
1) Intransitive Associations: "X has_and_belongs_to_many Y"
# "Two models are associated by simple virtue of their existence."
# A book can have many Authors, and an Author can have many Books.

rails g model Author name:string
rails g model Book title:string 
rails g migration CreateJoinTableAuthorsBooks authors books

class Book < ApplicationRecord
  has_and_belongs_to_many :authors
end
class Author < ApplicationRecord
  has_and_belongs_to_many :books
end

# Populate the database:
herman = Author.create name: 'Herman Melville'
moby = Book.create title: 'Moby Dick'
herman.books << moby

# Or in Leah's model:
def create
  unless current_user.nil?
    @author = Author.all.find_by(name: params[:name])
    @book = Book.new(book_params)
    @book.authors << @author
    @book.save

    redirect_to root_path
  end
end

# now you can call:
moby.authors
herman.books
herman.books.where(title: 'Moby Dick')

1) Mono-Transitive Associations: "X has_many Z through Y"
# A single additional model (relationship) defines the connection between two models. 
# A Student can be taught by many tutors, and a tutor can have many students, but they are connected THROUGH a Class Model
# "We can say that a Student is taught through attending Klasses and that a Tutor teaches Students through giving Klasses. The word through is important here, as we use the same term in ActiveRecord to define the association

# eg1) Users and Bookings:
rails g model User name:string etc
rails g model Booking duration:integer note:string etc
rails g model UserBooking user:references booking:references

class User
  has_many :user_bookings
  has_many :bookings, through: :user_bookings
end 

class Booking
  has_many :user_bookings
  has_many :users, through: :user_bookings
end

# Populate the DB:
josh = User.create(name: "josh", email: "josh@gmail.com", password: "password", user_id: 1)
josh_profile = Profile.create(user_id: josh.user_id, tutor?: false)

new_tutor = User.create(name: "sunny", email: "tutor@gmail.com", password: "password", user_id: 2)
new_tutor_profile = Profile.new(user_id: new_tutor.user_id, tutor?: true)

new_booking = Booking.create(location: "Skype", duration: 60, booking_id: 1)
new_user_booking = UserBooking.create(user_id: josh.user_id, booking_id: new_booking.booking_id, tutor: new_tutor.user_id)

# Now you can call:
new_user_booking.user_id => 1
new_user_booking.tutor => 2
new_user_booking.booking_id => 1

# get all users who had a skype booking:
User.joins(:bookings).where(bookings: {location: 'Skype'}).distinct.pluck(:name) => 'josh'


# eg2) Students and Tutors
rails g model Student name:string
rails g model Tutor name:string
rails g model Klass subject:string student:references tutor:references

class Student < ApplicationRecord
  has_many :klasses
  has_many :tutors, through: :klasses
end

class Tutor < ApplicationRecord
  has_many :klasses
  has_many :students, through: :klasses
end
class Klass < ApplicationRecord
  belongs_to :student
  belongs_to :tutor
end


# Populate the DB:
bart = Student.create name: 'Bart Simpson'
edna = Tutor.create name: 'Mrs Krabapple'
Klass.create subject: 'Maths', student: bart, tutor: edna


# Now you can call:
Student.find_by(name: 'Bart Simpson').tutors  # find all Bart's tutors
Student.joins(:klasses).where(klasses: {subject: 'Maths'}).distinct.pluck(:name) # get all students who attend the Maths class
Student.joins(:tutors).joins(:klasses).where(klasses: {subject: 'Maths'}, tutors: {name: 'Mrs Krabapple'}).distinct.map {|x| puts x.name} # get all students who attend Maths taught by Mrs Krabapple

====================================================================================================
// APIs // 
====================================================================================================
https://guides.rubyonrails.org/api_app.html

rails new appname --api 

post requests and CSRF authentication 
in controller: 
protect_from_forgery with: :null_session #turns off for entire session
protect_from_forgery :exception => :test #turns off for specific functin #test

// Where to put functions //

Keep as part of the data(base)
put in the model > then can call later with restaurant.function_name


// RENDERING JSON in the CONTROLLER //
# https://stackoverflow.com/questions/14824551/rendering-json-in-controller


====================================================================================================
// AUTHENTICATION // -- DEVISE 
====================================================================================================
https://github.com/plataformatec/devise
https://gist.github.com/leahgarrett/24476700469b9c2146b56448face56af
https://github.com/plataformatec/devise/wiki/How-Tos <- Tutorials / How To 
https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-with-something-other-than-their-email-address

gem 'devise' #authentication:

# run the generator:
rails generate devise:install

# create models and views for new Devise Model User:
rails generate devise User 
# this will replace MODEL with the class name used for the application’s users (it’s frequently User but could also be Admin). This will create a model (if one does not exist) and configure it with the default Devise modules. The generator also configures your config/routes.rb file to point to the Devise controller.


# Set up default URL options in config/environments/development.rb:
# eg default:
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
# Can use the default config from mailgun config.action_mailer.smtp_settings

next configure options:
# All of devise's configuration options are in the initializer:
initializers/devise.rb
# Additional options in the Model:
# If you add an option in the model, inspect the migration file (created by the generator if your ORM supports them) and uncomment the appropriate section. For example, if you add the confirmable option in the model, you'll need to uncomment the Confirmable section in the migration.
Trackable
Confirmable
Lockable
Database_authenticatable
Registerable
Recoverable
Rememberable 
Validatable
Timeoutable
Omniauthable

Then run 
rake db:migrate
> restart server else you get a method_error devise_user

CONTROLLER Filters and Helpers
# Controllers! (Models are below)
# Authentication for controllers and views
# For any controller, if you want to add authentication, add:
before_action :authenticate_user! #replace user with model_name
#to verify sign-in:
user_signed_in?
# Current signed-in user
current_user
# access session for this scope
user_session 
# customize redirect hooks
after_sign_in_path_for
after_sign_out_path_for

Custom Controllers;
# requires scope (users etc)
$ rails generate devise:controllers [scope]


MODEL configuration
# define which modules are included at the top. Check initializer file for more
devise :database_authenticatable, :registerable, :confirmable, :recoverable
# NOTE, Devise uses STRONG parameters, so if you want to parse attributes (through form etc) to a Devise model, requires special functions to do so. View docs for more info.s

VIEWS
# All views inside the gem. To copy to your app:
rails generate devise:views
# For multiple devise models, see docs

# to generate views for specific modules:
$ rails generate devise:views -v registrations confirmations

# for customisable controller:
$ rails generate devise:controllers [scope]
# To view users_controller: 
"rails generate devise:controllers users  # `/controllers/users/`"

ROUTES
# comes with default, but customisable with devise_for :users etc
devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

# NOTE: double check routes created by devise. There is no default /index or /users. Sign in is at http://localhost:3000/users/sign_in

FLASH MESSAGES
https://github.com/plataformatec/devise/wiki/I18n
# Devices uses flash messages with with I18n

### NOTE ###
If you want to have several different Device models sharing actions, best implement a role based approach (role column  or using an authorization gem like cancancan). Different Models cannot share the same controller for sign-in sign-out and so on. 

# Bootstrap flash messages:
# https://gist.github.com/fjahr/b3828b9f4e333e74ba1894687d65e055

# application.html.erb => 
<%= flash_messages %

# application_helper.rb =>
def bootstrap_class_for flash_type
  { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[flash_type.to_s] || flash_type.to_s
end

def flash_messages(opts = {})
  flash.each do |msg_type, message|
    concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do 
            concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
            concat message 
          end)
  end
  nil
end

ADDING_CUSTOM_FIELDS_TO_DEVISE:
http://www.peoplecancode.com/tutorials/adding-custom-fields-to-devise


REDIRECT_AFTER_LOGIN:
# add to routes:
devise_for :users, controllers: {confirmations: 'confirmations', registrations: 'users/registrations' }

# add to registrations_controller.rb:
  # The path used after sign up.
+  def after_sign_up_path_for(resource)
+    new_profile_path
+  end

  # The path used after sign up for inactive accounts.
+  def after_inactive_sign_up_path_for(resource)
+    new_profile_path
+  end

====================================================================================================
// SENDING WELCOME EMAILS //
====================================================================================================
https://stackoverflow.com/questions/36597212/devise-sending-welcome-email

RASTKO >>
to: app/models/user.rb
after_create :welcome_email #where :method_name
def welcome_email
  @user = self
  BookMailer.with(user: @user).new_member_email.deliver_now
end

to: book_mailer.rb
def new_member_email
  @user = params[:user]
  mail(to: @user.email, subject: 'Welcome etc')
end

to: app/views/book_mailer/new_member_email.html.erb
HTML message
<< RASTKO

CONFIRMABLE: (after confirmation) 
# https://stackoverflow.com/questions/36597212/devise-sending-welcome-email
# https://www.bogotobogo.com/RubyOnRails/RubyOnRails_Devise_Authentication_Sending_Confirmation_Email.php
# https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users
# https://stackoverflow.com/questions/7219732/missing-host-to-link-to-please-provide-host-parameter-or-set-default-url-optio

# add to models/users.rb :
devise :registerable, :confirmable

# create a migrations:
rails g migration add_confirmable_to_devise

# add this to the migration:
class AddConfirmableToDevise < ActiveRecord::Migration
  # Note: You can't use change, as User.update_all will fail in the down migration
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    # add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :users, :confirmation_token, unique: true
    # User.reset_column_information # Need for some types of updates, but not for update_all.
    # To avoid a short time window between running the migration and updating all existing
    # users as confirmed, do the following
    User.update_all confirmed_at: DateTime.now
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :users, :unconfirmed_email # Only if using reconfirmable
  end
end

# create the user views:
rails generate devise:views users

# run migration
rails db:migrate

# if you are not using reconfirmabel, edit this in initializers/devise.rb
config.reconfirmable = false

# redirecting a user after confirmation. 
# Create a new app/controllers/confirmations_controller:

class ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) # In case you want to sign in the user
    your_new_after_confirmation_path # without the redirect_to
  end
end

# your_new_after_confirmation_path will send you wherever you want, so try sending to an after_confirmation.html.erb view with instructions on next steps

# add this to routes:
devise_for :users, controllers: { confirmations: 'confirmations' } 
default_url_options :host => "localhost:3000" #default host can be anything


# solve 'missing host to link to' error in the confirmation email:
# add the following line to environment files:
config.action_mailer.default_url_options = { :host => "yourhost" }
# can be different 'yourhost' for each of production.rb test.rb development.rb (eg 'www.yourhost.com')

# restart the server

def after_confirmation
  welcome_email
end
# You can use after_confirmation to insert any logic, not just a mailer

https://www.rubydoc.info/github/plataformatec/devise/Devise%2FModels%2FConfirmable:after_confirmation

https://www.youtube.com/watch?v=INPqBOerfTw
1) Create Mailer rails g welcome_mailer
2) add to user.rb: after_create :welcome_email & def welcome_email end
user.rb

after_create :welcome_email
def welcome_email
  BookMailer.welcome_email(self).deliver_now
  redirect_to root_path, alert: "Thank you for registering"
end

====================================================================================================
// AUTHORIZATION // -- CANCANCAN
====================================================================================================
gem 'cancancan' #authorization

only admin users should be able to edit > use can can can

rails generate cancan:ability # generate model for cancancan
=> creates ability.rb

#efficient way to create a new user the first time 
||= guard clause -> first time it enters here, if theres no user, it or/equals into a new user
if left hand side is false, then or/equals no user

user ||= User.new
if user.admin?
  can :manage, :all #:manage means full CRUD
else
  can :read, :all #users can only read
end

add admin boolean to user model
rails generate migration AddAdminToUser admin:boolean
rails db:migrate

next >
create (seed) new admin user


next > Apply Authorisation to View
<% if can? :update, restaurant 
<%= link_to "edit", edit_restaurant_path(restaurant.id) 
... will hide the 'edit link'

also need to secure the endpoints

add to restaurants.controller.rb

// authorize_resource & load_and_authorize_resource //
# https://stackoverflow.com/questions/30840231/cancan-explanation-of-load-and-authorize-resource

load_and_authorize_resource:

> sets up a before_filter
> calls two methods: :load_resource & :authorize_resource

>>> load_resource (loads the resource from params) # makes a decision on whether it should obtain a new instance of a class (e.g. Post.new) or find a particular instance based on params[:id] (e.g. Post.find(params[:id])). That instance (or a collection of instances for actions like index) is assigned to corresponding instance variable of your controller action.
>>> authorize_resource # takes the resource instance and params[:action], and checks whether the action can be accessed for the given resource
... If no exceptions are raised, your code will execute against the instance @instance created at load_resource step
... As long as before_filter raises exceptions (resource is denied), will follow behaviour defined in CanCan::AccessDenied handling:

# https://github.com/ryanb/cancan/wiki/Exception-Handling

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

# Also available:
skip_load_and_authorize_resource
skip_load_resource
skip_authorize_resource

before_action: authenticate_user! << devise authentication

To load a resource through another parent resource:
# either: 
load_and_authorize_resource :through => :current_user, :singleton => true #singleton is only for has_one relationships
# or:
before_action :load_profile, only: [:update]
# where:
def load_profile
  @profile = current_user.profile
end


// Devise Confirmable //
https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users
https://github.com/plataformatec/devise/blob/master/lib/devise/models/confirmable.rb
https://stackoverflow.com/questions/4783392/how-do-i-enable-confirmable-in-devise
https://www.bogotobogo.com/RubyOnRails/RubyOnRails_Devise_Authentication_Sending_Confirmation_Email.php

# Confirmable is responsible to verify if an account is already confirmed to
#     # sign in, and to send emails with confirmation instructions.
#     # Confirmation instructions are sent to the user email after creating a
#     # record and when manually requested by a new confirmation instruction request.

====================================================================================================
// CODEACADEMY AUTHENTICATION //
==================================================================================================== 
<via the CodeAcademy Authentication Exercises>
https://www.codecademy.com/courses/rails-auth/lessons/authentication/exercises/authentication-login-i

The Request / Response cycle: 
https://www.codecademy.com/articles/request-response-cycle-dynamic
1) A user opens his browser, types in a URL, and presses Enter. When a user presses Enter, the browser makes a request for that URL.
2) The request hits the Rails router (config/routes.rb).
3) The router maps the URL to the correct controller and action to handle the request.
4) The action receives the request, and asks the model to fetch data from the database.
5) The model returns a list of data to the controller action.
6) The controller action passes the data on to the view.
7) The view renders the page as HTML.
8) The controller sends the HTML back to the browser. The page loads and the user sees it.

** SIGNING IN using has_secure_password and bcrypt password hashing

in user.rb (model)

def has_secure_password
end
# This method adds functionality to save passwords securely.
# uses bcrypt gem (need to add to gemfile) to save passwords securely using an algorithm
add first_name, last_name, email and password_digest to users table
# has_secure_password will use the bcrypt algorithm to securely hash a user’s password, which then gets saved in the password_digest column.
# Then when a user logs in again, has_secure_password will collect the password that was submitted, hash it with bcrypt, and check if it matches the hash in the database.

# Then, add to routes:
get 'signup' => 'users#new'
resources :users

# Then make a #new method in users_controller.rb (@user = Users.new)
# Then add a form_for with the fields of the @user object in new.html.erb
eg:
#to create an article based on Article model
<%= form_for @article, url: {action: "create"}, html: {class: "nifty_form"} do |f| %>
  <%= f.text_field :title %>
  <%= f.text_area :body, size: "60x12" %>
  <%= f.submit "Create" %>
<% end 
#or maybe this one?
<div class="login">
  <div class="container">
    <%= form_for :user, url: '/users' do |f| %
      <%= f.text_field :first_name, :placeholder => 'First Name' %
      <%= f.text_field :last_name, :placeholder => 'Last Name' %
      <%= f.text_field :email, :placeholder => 'Email' %
      <%= f.password_field :password, :placeholder => 'Password' %
      <%= f.submit "Sign up", :class => "form-btn" %
    <% end %
  </div>
</div>


# then we need to take in the data submitted in the sign-up form.
# # create a private user_params function:
def user_params
  params.require(:user).permit(:first_name etc)
end
# # add a create function:
def create
  @user = User.new(user_params)
  if @user.save
    session[:user_id] = @user.id #assigns the parsed user_id from the form to the current session :user_id
    redirect_to '/'
  else
    redirect_to '/signup'
  end
end
#sessions are stored as key,value pairs
#if user exists create will 'login' the user by creating a new session, and forwarding to '/', else it reloads the signup page

** LOGGING_IN: 
# Logging in requires a model, a controller, routes, views, and logic for sessions. Model is the User model.
To Create a login page
# need a controller rails g controller sessions
# add (empty) #new to sessions_controller
# add a form to views/sessions/new.html.erb

# uses :session instead of @session because there is no Session Model.
<%= form_for(:session, url: login_path) do |f| %>
  <%= f.email_field :email, :placeholder => "Email" %>
  <%= f.password_field :password, :placeholder => "Password" %>
  <%= f.submit "Log in", class: "btn-submit" %> 
<% end 

# In the login form, we use form_for(:session, url: login_path) do |f|. This refers to the name of the resource and corresponding URL. In the signup form, we used form_for(@user) do |f| since we had a User model. For the login form, we don’t have a Session model, so we refer to the parameters above.

# next add a sessions#create method and route:
post '/login' => 'sessions#create'

def create
  @user = User.find_by_email(params[:session][:email]) # checking the database for your email 
  if @user && @user.authenticate(params[:session][:password]) # checking the database for your email 
    session[:user_id] = @user.id
    redirect_to '/'
  else
    redirect_to 'login'
  end 
end 
# The create action checks whether your email and password exist in the database, creates a new session, and redirects to the albums page.

** LOGGING_OUT:
# create a new route that maps to the sessions_controller destroy method
delete 'logout' => 'sessions#destroy' 
# for the destroy method, set the session hash to nil and redirect to root path: 
def destroy 
  session[:user_id] = nil 
  redirect_to '/' 
end


CURRENT_USER: 
# We need to check whether the current user is signed in BEFORE sending a request to the controller #index action (thereby rendering the index page)
# Therefore 
# Add a helper method current_user and require_user to application_controller.rb:

helper_method :current_user
def current_user 
  @current_user ||= User.find(session[:user_id]) if session[:user_id] # checking db for user with session_id and stores that user to @current_user
end 

def require_user
  redirect_to '/login' unless current_user
end

# The current_user method determines whether a user is logged in or logged out. It does this by checking whether there’s a user in the database with a given session id.
# helper_method :current_user makes this method available in the views where require_user method is available within the controllers, use is 'before_action :require_user'
# require_user method uses current_user method to redirect users to login page if they're not signed in

# to use the require_user method, add this to Albums_controller:
# calls the require_user method before running #index or #show actions

before_action :require_user, only: [:index, :show]

# to use the current_user method in a view (to change the view depending on whether logged in or not)

<% if current_user %> 
  <ul> 
    <li><%= current_user.email %></li> 
    <li><%= link_to "Log out", logout_path, method: "delete" %></li> 
  </ul> 
<% else %> 
  <ul> 
    <li><%= link_to "Login", 'login' %></a></li> 
    <li><%= link_to "Signup", 'signup' %></a></li> 
  </ul> 
<% end 

====================================================================================================
// CODEACADEMY AUTHORIZATION //
==================================================================================================== 
<via the CodeAcademy Authorization Exercises>
https://www.codecademy.com/courses/rails-auth/lessons/authorization/exercises/authorization-user-model

How authorization fits into the request / response cycle

1) The browser makes a request for a URL
2) The request hits the Rails router
3) Before the router sends the request on to the controller action, the app determines whether the user has access permission by looking at the user’s role.

# Add string: role to users table
# Create a helper function in User Model to use with the 'role' column:

Require Editor:
eg:
def editor?
  self.role == 'editor'
end
> should be able to check in console matt.editor? (where matt is a User saved to variable mateo)

# now we can use editor? to make more helper methods in application_controller:
def require_editor
  redirect_to '/' unless current_user.editor?
end
# > can add this to Recipes_controller:
before_action :require_editor, only: [:show, :edit] #require editor role to be able to access show / edit actions
# > can add to recipes/show.html.erb to add edit button only if user is an editor:

<% if current_user && current_user.editor? %>
  <p class="recipe-edit">
    <%= link_to "Edit Recipe", edit_recipe_path(@recipe.id) %>
  </p>
< %end >

Require Admin:
# add a method named #admin? to Users model
# create a method require_admin in application_controller
# create a before_action in the Recipes_Controller that authorizes the destroy method
# use the admin? method to display a delete link in recipes/show.html.erb only if the use is an admin

def admin?
  self.role == 'admin'
end

def require_admin
  redirect_to '/' current_user.admin?
end

before_action :require_admin, only: [:destroy]  

<% if current_user && current_user.admin? %
  <p class='recipe-delete'><%= link_to 'Delete', 'delete_recipe_path(@recipe), method: :delete' %></p>
<% end 






====================================================================================================
// CANCANCAN //
====================================================================================================
https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
https://github.com/CanCanCommunity/cancancan/wiki/checking-abilities

# The can method is used to define permissions and requires two arguments. The first one is the action you're setting the permission for, the second one is the class of object you're setting it on.
can :update, Article

# Pass an Array to match multiple actions or objects:
can [:update, :destroy], [Article, Review]

if user.present? #define other permission for logged in users
if user_signed_in? #same?? > seen in html.erb file to determine what is displayed

# can :manage, :all with a cannot to turn off one specific permission eg:
can :manage, Project # but...
cannot :destroy, Project

can :update, Project if user.admin?
====================================================================================================
HASH of CONDITIONS
====================================================================================================
# can :action, Model, hash without curly braces
# it is important to only use database columns on conditions so records can be fetched from the db

can :read, Project, active: true, user_id: user.id
# Here the user will only have permission to read active projects which they own.

====================================================================================================
SET ABILITES validated by a BLOCK:
====================================================================================================
can :update, Project do |project|
  project.priority < 3
end
#If the block returns true then the user has that ability, otherwise he will be denied access.

can :read, Article, Article.published do |article|
  article.published_at <= Time.now
end
# can [:ability], Model, Model.scope_to_select_on_index_action do |model_instance|
  # model_instance.condition_to_evaluate_for_new_create_edit_update_destroy
# end

# Set abilities depedent on status of an object attribute:
can :read, Project, released: true
can :read, Project, preview: true

====================================================================================================
ALIAS ACTIONS:
====================================================================================================
def initialize(user)
  alias_action :create, :read, :update, :destroy, to: :crud
  if user.present?
    can :crud, User
    can :invite, User
  end
end
# If you want only CRUD actions on object, you should create custom action that called :crud for example, and use it instead of :manage:

====================================================================================================
EXAMPLE LOGIN USING CANCANCAN and DEVISE:
====================================================================================================
# add the following to application.html.erb: 

<body>
  <div class="container">
    <div id="navbar" class="navbar">
    <ul class="nav navbar-nav">
      <li><%= link_to 'Home', root_path %></li>
    </ul>
    <ul class="nav navbar-nav pull-right">
      <% if user_signed_in? %>
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu" role="menu">
            <li><%= link_to 'Profile', edit_user_registration_path %></li>
            <li><%= link_to 'Log out', destroy_user_session_path, method: :delete %></li>
          </ul>
        </li>
      <% else %>
        <li><%= link_to 'Log In', new_user_session_path %></li>
        <li><%= link_to 'Sign Up', new_user_registration_path %></li>
      <% end %>
    </ul>
  </div>
  <% flash.each do |key, value| %>
    <%= value %>
  <% end %>
  <%= yield %>
</body>




====================================================================================================
// CRUD - Controller & HTML.ERB //
====================================================================================================
<%= link_to 'Edit', edit_article_path(article) %></td>
<%= link_to 'Show', article_path(article) %>
<%= link_to 'Destroy', article_path(article), method: :delete, data: { confirm: 'Are you sure?' } %>


====================================================================================================
// RENDER / REDIRECT_TO //
====================================================================================================
https://gist.github.com/DeepNeuralAI/485f3444ed3538eafd8f67bd8f80d241

2 ways to create http response
a) RENDER :index
=> tells rails which view to use
=> when not excplicit will look for the action based on the name. eg def index will automatically look for index.html.erb
=> can render a template within the same folder
eg: render 'edit' / render :edit
=> can render a template from another controller
eg: render 'restaurants/new'
=> can render a file render file: '/file_path' ?? dont need to include file path

pass variables to render
<%= render: "link", user: current_user %> # gets user from Devise
# use this with partials to add information to to of a page

b) REDIRECT_TO
=> tells the browser to send a new request for a url (go back to routes, look for 'new' etc, and run whatever is in that method)
=> sends you to a specific route
=> will not halt, will still execute code ocurring after

// Be careful - render 'page' will IMMEDIATELY render the page, meaning if a page relies on data from a model it wont be parsed


====================================================================================================
// PARTIALS //
====================================================================================================
https://gist.github.com/DeepNeuralAI/485f3444ed3538eafd8f67bd8f80d241

Convention: create directory layours/shared
Each file named: _filename.html.erb
Then: add to application.html.erb
<%= render "layouts/shared/navbar" %> # dont need the underscore %>



Modularise for easy debugging
DRY

navbar
footer
sidebar
forms


====================================================================================================
// MAILER // --Mailgun
====================================================================================================
https://gist.github.com/DeepNeuralAI/b56f45ba980aed4650625765a165297c

CORE: 
sign-up for mailgun
add verified recipient (dashboard > click on domain > add REAL email address)
copy down user data to paste to code (SMTP)

define which email you send from  application_mailer.rb
define when email is created in app/mailers/book_mailer.rb <method>
place method in controller to control when email is created/sent (eg under create method)

HOW_TO:
rails g mailer BookMailer
# > creates app/mailers/book_mailer.rb
# > app/views/book_mailer directory
# >test and preview in test/mailers

# sign up for MailGun > mailgun.com

# add a verified user to test emails (mailgun will only let you send verified emails)

# SMTP, mailgun gives unique smtp information
# take that info, and put into config/environments/development.rb file:

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address:              'smtp.mailgun.org',
  port:                 587,
  domain:               '<sandbox_something...>',
  user_name:            '<username>',
  password:             '<password>',
  authentication:       'plain',
  enable_starttls_auto: true }


# Configure the app/mailers files:
# 1) application_mailer, configure the default from email address (must be a real address):
class ApplicationMailer < ActionMailer::Base
  default from: 'joshteperman@gmail.com'
  layout 'mailer'
end

# 2) MailerName.rb, add functions for different emails, parsing model data to the mailer. 

# eg: if we want to send an email every time user creates/adds a book, send email
def new_book_email
  @user = params[:user]
  mail(to: @user.email, subject: 'A new book was added')
end
# >> will be called from within the books_controller in the #create method
# BookMail.with(user: @user).new_book_email.deliver_now 

# eg: sending a welcome email:
def welcome_email
  @user = params[:user]
  mail(to: @user.email, subject: 'Welcome to APPNAME')
end



for compatibility, craete two files to view/book_mailer/:
  new_book_email.html.erb
  new_book_text.html.erb

to call the method, in this case call in create within books_controller
  new book created
  @book.save

  @user = current_user
  BookMail.with(user: @user).new_book_email.deliver_now # > @user goes to params[:user in maileser/book_mailer.rb ]
  redirect_to root_path


For production (Heroku), add this to production.rb:
`config.action_mailer.default_url_options = { :host => 'YOURAPPNAME.herokuapp.com' }`


----
Tim Mailgun
----

# If anyone is implementing mailgun I recommend putting it in the credentials in credentials.yml.enc using that EDITOR=vim rails credentials:edit crap (that command is probably wrong so look at JOLI for the actual command)

# Put this in the credentials.yml.enc file, theyll be available in your mailgun dashboard somewhere:

    mailgun:
    smtp_address: <smtp address>
    smtp_port: 587
    username: <username>
    password: <password>
    domain: <your domain> (should be a heap of random letters and numbers)

# Then you can reference those credentials in your production/development environment files
/config/environment/development.rb
/config/environment/production.rb

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              Rails.application.credentials.dig(:mailgun, :smtp_address),
    port:                 Rails.application.credentials.dig(:mailgun, :smtp_port),
    domain:               Rails.application.credentials.dig(:mailgun, :domain),
    user_name:            Rails.application.credentials.dig(:mailgun, :username),
    password:             Rails.application.credentials.dig(:mailgun, :password),
    authentication:       'plain',
    enable_starttls_auto: true
  }

====================================================================================================
// STRIPE // 
====================================================================================================
 
gem 'stripe'
gem 'dotenv-rails', groups: [:development, :test] 
# user specific information on your local machine but not on the internet
# still push to github, but tells github to look inside private ENV file to find the API key
# very important for payments!!!

sign up for stripe
get a publishable key and secret key

CONTROLLER:
rails g controller charges
# controller specifically for purchases - can call this controller anything
#controller does two things:
1) show credit card form using stripe checkout
2) create charges by calling the stripe API

Add methods create and new to controller/charges.rb
# copy controller methods from: stripe.com/docs/checkout/rails 

Define the ROUTES:
resources :charges

ADD STRIPE CREDENTIALS to new file:
root/.env
> copy the publishable key from home page
PUBLISHABLE_KEY=pk_test_**key**
SECRET_KEY=sk_test_**key**
# Stripe will then be able to access key through the .env file, but only ENV['PUBLISHABLE_KEY'] is pushed
# paste to hidden config file in Heroku during production

add to git ignore:
.env*

add to 
config/initializers/stripe.rb #need to create the file

Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]

Create VIEW:
1) Strip_Purchase FORM:
app/views/layouts/books/_stripe_form.html.erb
# from the docs
<%= form_tag charges_path do %>
  <article>
    <% if flash[:error].present? %>
      <div id="error_explanation">
        <p><%= flash[:error] %></p>
      </div>
    <% end %>
    <label class="amount">
      <span>Amount: $5.00</span>
    </label>
  </article>

  <script src="https://checkout.stripe.com/checkout.js" class="stripe-button"
          data-key="<%= Rails.configuration.stripe[:publishable_key] %>"
          data-description="Purchase Book"
          data-amount="500"
          data-locale="auto"></script>
          data-currency="aud" #default is USD
<% end 


2) Payment Confirmation Page:
create.html.erb view under app/views/charges

<h2>Thanks, you paid <strong>$5.00</strong>!</h2>


test payment
4242 4242 4242
01/21
123

CHALLENGE:
send email on Sign-up
keep track of transactions in DB



====================================================================================================
// DEBUGGING in RAILS // 
====================================================================================================
binding.pry > still gives you access if you run within vscode
raise > does the same thing but stops it at a certain point within your browser
... same thing as rails console
> @books #in terminal
> current_user

In console:
user = User.new
user.valid? => if returns false, then
user.errors

====================================================================================================
// MISC //
====================================================================================================

# To make secure: 
run before (method that runs before any request and makes sure the user is authorised)

<form action="<%= movies_path %>" method="POST" >
# action here is the rails routes.rb Controller#Action, specified by the prefix_path movies (or end-point movies)
# action-path movies + Verb POST references Controller=Movies and Action=Create, or "movies#Create"
# therefore movies#create will run create method in movies_controller.rb
=> movies end point has POST request defined as create, therefore calls create from movies_controller.rb

redirect_to @movie
=> automatically builds the path movies/:id based on @movie.id

add custom message to confirmation on deleting:
data: 'message' ??

// Tips for collaborating with different database states & different users & differet OS etc // 
- when collaborating accross mac / windows, need to add .config files etc to .gitignore (config/database.yml??)
- use seed to hard-code admin user etc

# Add Model with foreign_key at the same time:
rails generate model Restaurant name address description user:references


#select based on boolean attribute
User.select(&:admin?) #select Users that are admin


// LAZY LOADING VS EAGER LOADING: // 
# https://www.spritle.com/blogs/2011/03/17/eager-loading-and-lazy-loading-in-rails-activerecord/
# https://revs.runtime-revolution.com/conditional-eager-loading-in-rails-9b1c1c592897

posts = Post.includes(:comments).limit(20)

# vs
posts = Post.all(:limit => 20)

.. 
# Note: You may be tempted to use the published scope to filter the books like this:
published_books = author.books.published
# Filtering in the database
# An alternative solution to filter the association data in memory is to do it in the database so that we only retrieve the data we need.
authors = Author.includes(:books).where(books: { published: true })

// Scoped Associations //
# There is one last alternative to filter the data from an association. As we have seen, using the includes method ActiveRecord can perform eager loading for us for a given association without any problem.
# Instead of trying to filter the association in the main query, we can define an association that only gets the filtered data. The associations api allows us to specify additional conditions to get the associated data. So looking again at our Author model, we can define a published_books association. It looks like this:
class Author
  has_many :books
  has_many :published_books, -> { where(published: true) }, class_name: 'Book'
end
# Then all you have to do is just eager load this new association.
authors = Author.includes(:published_books)
# --> This approach does not have the same issue has the last one. It will load all the authors whether they have published books or not
.. --> # User .includes().where will use Left Join, which on returns resources where both tables match the data, ie: won't return authors who don't have published books
HOWEVER... #If you have some condition that is only known at runtime, you have no way to specify an association for that condition. A typical example of this is any condition that involves the current_user, we would need to access the current_user_published_books data, but can't access current_user from within the Model.
.. --> # In this case we can mix approaches
authors = Author.includes(:published_books).where(books: { user_id: current_user.id })


Install Emmet for HTML.ERB
"emmet.includeLanguages": {"erb": "html"} as mentioned by @coisnepe
Install "erb
Craig Maslowsk " extensions..... it helps erb syntax highlighting


--------

has_one :profile

def create
  @user = current_user
  @profile = current_user.create_profile(profile_params)
  @profile.save
end


MIGRATIONS: Change Column Name 
rails g migration ChangeColumnName
rails g migration RenameColumn


def change
  rename_column :users, :email, :email_address
  # rename_column :table_name, :old_column, :new_column
end

SELECT_RANDOM_OBJECT_FROM_MODEL:
offset = rand(Model.count)

# Rails 4
rand_record = Model.offset(offset).first


# https://stackoverflow.com/questions/25146008/activerecord-what-does-index-true-mean
index: true
# creates a non-unique index within the database at that point
# useful when you have a large amount of data as normal search and extract becomes less efficient


UNIQUE_TRUE:

unique: true
t.string :city, index: {unique: true}

add_index :table_name, :column_name, unique: true

# To index multiple columns together, you pass an array of column names instead of a single column name,
add_index :table_name, [:column_name_a, :column_name_b], unique: true

rails generate migration add_index_to_table_name column_name:uniq

:validates_uniqueness_of


// Add auto-incrementing column: //
https://www.quora.com/How-do-I-add-an-extra-auto-increment-column-in-a-Rails-4-model-when-that-column-is-not-a-primary-key

1) 
before_create :set_tutor_id
def set_tutor_id
  last_tutor_id = User.maximum(:tutor_id)
  self.tutor_id = tutor_id.to_i + 1
end

2) 
https://stackoverflow.com/questions/615272/add-auto-increment-back-to-primary-key-column-in-rails
change_column :table_name, :id, :int, null: false, unique: true, auto_increment: true



AWS Keys & Encryption:
Credentials on Githib - encrypted
MasterKey decrypts that (by default in Git Ignore)


psql -U josh rails_coding_tutor_development
SELECT setval('model_name', starting_value);


// VALIDATIONS: //
https://edgeguides.rubyonrails.org/active_record_validations.html

https://guides.rubyonrails.org/v2.3.11/activerecord_validations_callbacks.html
-> validation callbacks

validates :attribute, presence: true
validates :name, :login, :email, presence: true


validates :size, inclusion: { in: %w(small medium large) }

validates :name, length: { minimum: 2 }
validates :bio, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }

validates :games_played, numericality: { only_integer: true }

validates :email, uniqueness: true
validates :name, uniqueness: { case_sensitive: false }

Allow_nil:
validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }, allow_nil: true

Error_message:
# A Proc :message value is given two arguments: the object being validated, and a hash with :model, :attribute, and :value key-value pairs.
validates :name, presence: { message: "must be given please" }

:if :unless 
validates :password, confirmation: true, unless: Proc.new { |a| a.password.blank? }
validates :password, confirmation: true, unless: -> { password.blank? }
validates :card_number, presence: true, if: :paid_with_card?


multiple validations with one condition:
with_options if: :is_admin? do |admin|
  admin.validates :password, length: { minimum: 10 }
  admin.validates :email, presence: true
end

Custom_method:

class Invoice < ApplicationRecord
  validate :expiration_date_cannot_be_in_the_past,
    :discount_cannot_be_greater_than_total_value
 
  def expiration_date_cannot_be_in_the_past
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "can't be in the past")
    end
  end
 
  def discount_cannot_be_greater_than_total_value
    if discount > total_value
      errors.add(:discount, "can't be greater than total value")
    end
  end
end

# https://hackernoon.com/performing-custom-validations-in-rails-an-example-9a373e807144
# Performing validations within the model works fine, but it also adds more logic to the model. I prefer to extract that logic to its own helper class when possible. That’s because it nicely encapsulates each validation’s logic to its own object, making it easier to debug and/or extend in the future.
# Let’s validate the density by creating a helper validator class. The #validates_withmethod points the validation at a helper class:

class Shipment < ActiveRecord::Base
  validates_with DensityValidator
end

# /models/concerns/density_validator.rb
class DensityValidator < ActiveModel::Validator
  def validate(record)
    if record.density > 20
      record.errors.add(:density, “is too high to safely ship”)
    end
  end
end
# DensityValidator inherits from ActiveModel::Validator, whose convention is there to be a method called #validate. 
# The method has access to the entire record and implements the validation logic, assigning errors if needed:




Validate_if_condition:
validates :description, presence: true, if: -> {current_step == steps.first || require_validation}

Display errors in view:

<% if @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited this article from being saved:</h2>
 
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %




// ACTIVE STORAGE //
<label for="images[]">Upload images</label>
<input type="file" name="images[]" multiple="true" accept="image">
Params.require(:product).permit(images: [])




// RSPEC //

https://github.com/rspec/rspec-rails

# Gemfile
group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end

bundle install
rails generate rspec:install
# create  .rspec
# create  spec
# create  spec/spec_helper.rb
# create  spec/rails_helper.rb