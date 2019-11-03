## Definitions
- Definition
  - Defining your schema
- Root types
  - Root types are the entry points for queries, mutations, subscriptions
- 

## Structure

```
ROOT: Graphql Directory

-- schema.rb
objects (or types)
  -- base_object.rb           -> extends GraphQL::Schema::Object
  -- root_query_object.rb     -> extends BaseObject
  -- root_mutation_object.rb  -> extends BaseObject
  -- organisation_object.rb   -> extends BaseObject
  -- 
mutations
  -- base_mutation.rb         -> extends GraphQL::Schema::Mutation
  -- login_mutation.rb        -> extends BaseMutation
enums 
  -- base_enum.rb             -> extends GraphQL::Schema::Enum
  -- constants.rb
  -- user_type_enum.rb
  -- payment_method_enum.rb
input_objects
  -- base_input_object.rb
  -- authentication_input_object.rb
  -- sort_input_object.rb
```

```
// schema.rb

class <AppName>Schema < GraphQL::Schema
  mutation(Objects::RootMutationObject)
  query(Objects::RootQueryObject)
end
```

```
// graphql_controller.rb

class GraphqlController < ActionController::Base
  def execute
    variable = ensure_hash(params[:variables])
    query = params[:query]
    operation_name: params[:operationName]
    user = AuthenticationService.authenticate(request) || current_user

    organisation_id = request.session[:current_organisation_id]
    organisation = Organisation.find_by(id: organisation_id)

    context = {
      user: user
      organisation: organisation
      request: request
      response: response
      warden: warden
    }

    result = Schema.execute(query, variables: variables, context: context, operation_name: operation_name)

    render json: result
  end

  private

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
       ensure_hash(JSON.parse(ambiguous_param))
      else 
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
```

```
// root_query_object.rb

module Objects 
  class RootQueryObject < BaseObject
    description 'These fields serves all the data used by this App'

    field :admin, AdminObject, 'Data for admin purposes', null: false
    field :student, User::StudentObject, 'Data for student purpose', null: false
    field :teacher, User::TeacherObject, 'Data for teacher purpose', null: false

    def admin
      return user if user.class == AdminUser

      Objects::Errors::UnauthorizedErrorObject.new('Unauthorized')
    end

    def student
      return user if user.class == User && user.student?

      Objects::Errors::UnauthorizedErrorObject.new('Unauthorized')
    end

    def teacher
      return {
        user: user,
        organisation: organisation,
      } if user.class == User && user.teacher?

      Objects::Errors::UnauthorizedErrorObject.new('Unauthorized')
    end

    private

    def user
      context.fetch(:user)
    end

    def organisation
      context.fetch(:organisation)
    end
  end
end
```

```
// root_mutation_object.rb

module Objects
  class RootMutationObject < BaseObject
    field :admin, AdminMutationObject, 'Actions for Admin', null: false
    field :create_user_password, mutation: Mutations::CreateUserPasswordMutation
    field :login, mutation: Mutations::LoginMutation
    field :reset_password, mutation: Mutations::ResetPasswordMutation
    field :weployee, WeployeeMutationObject, 'Actions for Weployees', null: false

    def admin 
      user = context.fetch(:user)
      return user if user.class == AdminUser

      Objects::Errors::UnauthorizedErrorObject.new('Unauthorized')
    end

    def weployee
      user = context.fetch(:user)
      return user if user.class == User && user.weployee?

      Objects::Errors::UnauthorizedErrorObject.new('Unauthorized')
    end
  end
end
```

```
// base_object.rb

module Objects
  class BaseObject < GraphQL::Schema::Object
  end
end

// base_mutation.rb

module Objects
  class BaseMutation < GraphQL::Schema::Object

  end
end
```

```
// organisation_object.rb

modules Objects
  class OrganisationObject < BaseObject
    field :name, String, 'The name of the organisation', null: false
    field :website, String, 'The organisation\'s website', null: false
  end
end
```

```
module Mutations
  class LoginMutation < BaseMutation
    UNAUTHORIZED_MESSAGE = 'Unable to authenticate using email or password'.freeze

    argument :email, String, 'The email used for login', required: true, prepare: ->(value, _ctx) { value.downcase }

  end
end
```
## Context

You can provide application-specific values to GraphQL as context:. This is available in many places:

- resolve functions
- Schema#resolve_type hook
- ID generation & fetching

Common uses for context: include the current user or auth token. To provide a context: value, pass a hash to Schema#execute:

```
context = {
  current_user: session[:current_user],
  current_organization: session[:current_organization],
}

MySchema.execute(query_string, context: context)
Then, you can access those values during execution:

field :post, Post, null: true do
  argument :id, ID, required: true
end

def post(id:)
  context[:current_user] # => #<User id=123 ... >
  # ...
end
```

Note that context is not the hash that you passed it. It’s an instance of `GraphQL::Query::Context`, but it delegates `#[]`, `#[]=`, and a few other methods to the hash you provide.