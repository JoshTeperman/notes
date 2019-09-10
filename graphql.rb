# GraphQL is a Query language for your API, and server-side runtime for eecuting queries by using a type system you define for your data.

#! Pros

# Get only the data you need
# Single requests vs multiple requests to multiple endpoints
# Request logic created by the client, reduces dependencies on backend api versions
# Changes to request format won't break the code

# ! Basic Rails app:
# https://www.howtographql.com/graphql-ruby/1-getting-started/

Gems:
rails;
bundler;
sqlite;
gem 'graphql'

rails new 
bundle exec rails db:create
bundle exec rails graphql:install
# ~/Gemfile:
gem 'graphiql-rails', group: :development

# create model:
rails g model Link url:string description:string
rails db:migrate

# ~/app/models/link.rb
class Link < ApplicationRecord
end

# create some Links
```
rails c 
Link.create url: 'http://graphql.org/', description: 'The Best Query Language'
Link.create url: 'http://dev.apollodata.com/', description: 'Awesome GraphQL Client'
exit
```

#!  Query for returning Links:

# Define your GraphQL type :

# ~/app/graphql/types/link_type.rb

`field :field_name, data_type, null: false`

module Types
  class LinkType < BaseObject
    field :id, ID, null: false
    field :url, String, null: false
    field :description, String, null: false
  end
end

# Define your Query Resolver:
# Your type is now defined, but the server doesn't know how to handle it. 
# Resolvers are functions that the GraphQL server uses to fetch the data for a specific query.
# Each field of your GraphQL type needs a corresponding resolver function.
# When a query arrives at the backend, the server will call the corresponding resolver functions to the fields that are specified in the query.
# All GraphQL queries start from the root type Query at:

# ~/app/graphql/types/query_type.rb

module Types
  class QueryType < BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # queries are just represented as fields
    # `all_links` is automatically camelcased to `allLinks`
    # field and def method_name must be the same, and can be anything

    field :all_links, [LinkType], null: false

    # this method is invoked, when `all_link` fields is being resolved
    def all_links
      Link.all
    end
  end
end


# test abiity to make query at iGraphQL:

{
  allLinks {
    id
    url
    description
  }
}

# =>

{
  "data": {
    "allLinks": [
      {
        "id": "1",
        "url": "http://graphql.org/",
        "description": "The Best Query Language"
      },
      {
        "id": "2",
        "url": "http://dev.apollodata.com/",
        "description": "Awesome GraphQL client"
      }
    ]
  }
}

# ! Mutations

# All GraphQL mutations start from a root type Mutation auto-generated in ~/app/graphql/types/mutation_type.rb
# default looks like this:
module Types
  class MutationType < BaseObject
    field :test_field, String, null: false, description: 'An example field added by the generator'
    def test_field
      'Hello World'
    end
  end
end

# Both the mutation type and query type are automatically exposed in the schema:

# ~/app/graphql/project_name_schema.rb
class ProjectNameSchema < GraphQL::schema
  query Types::QueryType
  mutation Types::MutationType
end