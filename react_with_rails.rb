WEBPACK=REACT::
-> pure webpacker

rails new joshteperman-website -T --webpack=react --database=postgresql --skip-spring
--webpack=react # is the same as:
bundle exec rails webpacker:install
bundle exec rails webpacker:install:react

# webpacker:install:react performs the following tasks:
Copying babel.config.js to app root directory
Updating webpack paths to include .jsx file extension
# add all relevant dependencies
├─ @babel/preset-react@7.0.0
├─ babel-plugin-transform-react-remove-prop-types@0.4.24
├─ prop-types@15.7.2
├─ react-dom@16.9.0
└─ react@16.9.0

# this will create a new app/javascript/packs directory where webpacker will bundle JS, CSS, React files etc
# you get an app/javascript/packs/application.js, referenced as the 'application' bundle

# to use React components in views use the javascript_pack_tag:
<%= javascript_pack_tag 'application' %> >
<%= stylesheet_pack_tag 'application' %> >

# To display React views in single-page React applications:
...

# running server in development mode unless NODE_ENV is specified:
NODE_ENV=development
.bin/webpack-dev-server # installed as dev dependency
.bin/webpack --watch

# running in production mode by default unless NODE_ENV is specified
NODE_ENV=production
bundle exec rails assets:precompile
bundle exec rails webpacker:compile
# both rake tasks will compile packs in production mode but will use RAILS_ENV to load configuration from config/webpacker.yml (if available).


# component file in app/javascript/packs/*.jsx is bundled in rendered in a view using javascript_pack_tag with the same name

ReactDOM.render(
  <App />,
  document.body.appendChild(document.createElement('div')),
)

ReactDOM.render(
  <App />,
  document.querySelector('#root')
)
# a second document.querySelector('#root') will overwrite the contents of the first

# DOM elements get rendered before content_for do block elements
# javascript_pack_tags are rendered first in the DOM
# # but when using render to #root div, the yield must be within the #root div or they will not be rendered (although normal HTML elememnts will still be rendered)
# yield appears to overwrite content_for content within named yield elements, therefore if content_for named yield elements are first they will not appear on the DOM. Putting them after the main yield allow them to be displayed.
# when rendering with document.body.appendChild, the elements will be added to the DOM in order (compared to other named yields)

simplest_structure:
controller.rb -> controller_index.html.erb -> <%= javascript_pack_tag 'index' %>
index.js -> { ReactDOM.render(<App.js>, document.querySelector('#root')) }
App.js -> const App = () => { <Component /> }

// WEBPACKER_REACT:
# https://github.com/renchap/webpacker-react

# includes both a ruby gem and a JS module
gem 'webpacker-react', "~> 1.0.0.beta.1"
bundle install
yarn add webpacker-react

# first step is to register your components in app/javascript/packs/*.js
# for example if you have component /packs/Hello.js

import Hello from './components/Hello';
import WebpackerReact from 'webpacker-react';
WebpackerReact.setup({ Hello })

import WebpackerReact from 'webpacker-react'
const App = () => {}
WebpackReact.setup({ App })

# now you can render components from your views:
<%= react_component('Hello', prop1: 'Some Prop') %> >
# use tag: hash to customise rendered HTML:

# or from a controller:
def main
  render react_component: 'Hello', props: { prop1: 'Some Prop' }
end

# use tag_options to customise the generated HTML:
render react_component: 'Hello', props: { prop1: 'Some Prop' }, tag_options: { tag: :span, class: 'my-custom-component' }

// REACT_RAILS::

# https://github.com/reactjs/react-rails
# example App Repo:
# https://github.com/BookOfGreg/react-rails-example-app

gem 'webpacker'
gem 'react-rails'

bundle install
bundle exec rails webpacker:install
bundle exec rails webpacker:install:react
bundle exec rails g react:install

app/javascript/components/ # directory for your React components
app/javascript/packs/application.js # ReactRailsUJS setup
app/javascript/packs/server_rendering.js # for server-side rendering
# add some //= require(s) to application.js

# to use React components in views add a javascript_pack_tag to your layout that will contain all your React components:
<%= javascript_pack_tag 'application' %> >

# create a new component
rails g react:component HelloWorld greeting:string
# component added to:
app/javascript/components/HelloWorld.js
# render it in a view:
<%= react_component('Exact Component Name', { prop_hash }) %> >
<%= react_component("HelloWorld", { greeting: "Hello from react-rails." }) %> >
<%= react_component("StoriesList", { stories: @stories}) %> > # where @stories is an array of stories

const StoriesList extends React.Component {
  const { stories } = this.props
}

# optionally render components using rails controller and the render component method
class TodoController < ApplicationController
  def index
    @todos = Todo.all
    render component: 'TodoList', props: { todos: @todos }, tag: 'span', class: 'todo'
  end
end

# GEMLIST

gem 'graphql'
gem 'jwt'
gem 'devise'
gem 'dotenv-rails'

gem 'factory_bot_rails'
gem 'pry-byebug'
gem 'rspec-rails'
