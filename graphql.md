## Definitions
- Definition
  - Defining your schema
- Root types
  - Root types are the entry points for queries, mutations, subscriptions
-

## Structure
```
app/controllers/graphql_controller.rb

ROOT: Graphql Directory
-- schema.rb
objects (or types)
  -- base_object.rb           -> extends GraphQL::Schema::Object
  -- root_query_object.rb     -> extends BaseObject
  -- root_mutation_object.rb  -> extends BaseObject
  -- organisation_object.rb   -> extends BaseObject
mutations
  -- base_mutation.rb         -> extends GraphQL::Schema::Mutation
  -- login_mutation.rb        -> extends BaseMutation
enums
  -- base_enum.rb             -> extends GraphQL::Schema::Enum
  -- user_type_enum.rb
  -- payment_method_enum.rb
  -- constants.rb
input_objects
  -- base_input_object.rb
  -- authentication_input_object.rb
  -- sort_input_object.rb
errors
  -- base_error_object.rb           -> extends GraphQL::ExecutionError
  -- unauthorized_error_object.rb   -> extends BaseErrorObject
  -- invalid_error_object.rb        -> extends BaseErrorObject
  -- constants.rb
```

### Graphql Controller
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

### Schema
```
// schema.rb
// defines the entry point for queries and mutations

class <AppName>Schema < GraphQL::Schema
  mutation(Objects::RootMutationObject)
  query(Objects::RootQueryObject)
end
```

### Objects
```
// base_object.rb

module Objects
  class BaseObject < GraphQL::Schema::Object
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
// organisation_object.rb

modules Objects
  class OrganisationObject < BaseObject
    field :name, String, 'The name of the organisation', null: false
    field :website, String, 'The organisation\'s website', null: false
  end
end
```

### Mutations
```
// base_mutation.rb

module Objects
  class BaseMutation < GraphQL::Schema::Object
  end
end
```

```
// login_mutation.rb

module Mutations
  class LoginMutation < BaseMutation
    UNAUTHORIZED_MESSAGE = 'Unable to authenticate using email or password'.freeze

    argument :email, String, 'The email used for login', required: true, prepare: ->(value, _ctx) { value.downcase }
    argument :password, String, 'The password used for login', required: true
    argument :user_type, Enums::UserTypeEnum, 'The role of the user logging in', required: true
    argument :authentication_type, Enums::AuthenticationtypeEnum, 'Type of information to be stored in cookie for authentication', required: false

    field :authentication_token, ID, 'The session token', null: true
    field :user_id, ID, 'the UUID of the authenticated user', null: true

    def resolve(email:, password: user_type:, authentication_type: nil)
      case authentication_type
      when Enums::AuthenticationTypeEnum::JWT
        resolve_jwt_cookie_login(emil, password, user_type)
      when Enums::AuthenticationTypeEnum::DEVISE_SESSION
        resolve_devise_session_login(emil, password, user_type)
      else
      resolve_session_login(email, password) # Only works for weployees, user_type is ignored
    end

    private

    def resolve_jwt_cookie_login(email, password, user_type)
      use_case = Sessions::CreateJWT.call(nil, email: email, password: password, user_type: user_type)

      return process_jwt(use_case.value!) if use_case.success?

      Objects::Errors::UnauthorizedErrorObject.new(UNAUTHORIZED_MESSAGE)
    end

    def resolve_devise_session_login(email, password, user_type)
      user = User.find_by(email: email)

      if user.nil?
        Rails.logger.info "[LoginMutation] Could not find user with email: #{email}"
        return Objects::Errors::UnauthorizedErrorObject.new(UNAUTHORIZED_MESSAGE)
      elsif user.weployee?
        Rails.logger.info "[LoginMutation] Weployee attempted to login to Weployer app with email: #{email}"
        return Objects::Errors::UnauthorizedErrorObject.new(UNAUTHORIZED_MESSAGE)
      elsif !user.valid_password?(password)
        Rails.logger.info "[LoginMutation] Password is invalid for use with email: #{email}"
        return Objects::Errors::UnauthorizedErrorObject.new(UNAUTHORIZED_MESSAGE)
      end

      warden_set_user(user, scope: user_type.downcase.to_sym)

      Rails.logger.info "[LoginMutation] successful user login with email: #{email}"
      { authentication_token: nil, user_id: user.id }
    end

    def resolve_session_login(email, password)
      use_case = Sessions::CreateSession.perform(email: email, password: password)

      return use_case.session if use_case.success?

      Objects::Errors::UnauthorizedErrorObject.new(UNAUTHORIZED_MESSAGE)
    end

    def process_jwt(args)
      jwt = args.fetch(:jwt)
      user_id = args.fetch(:user_id)
      cookie_args = {
        jwt: jwt
        path: context[:request_path]
        secure: context[:secure]
      }
      set_jwt_in_cookie(context[:response], cookie_args)

      { authentication_token: jwt, user_id: user_id }
    end

    def set_jwt_in_cookie(response, jwt:, path:, secure:)
      # This will set a cookie on the client as well as returning all the
      # token data in the response body, including a CSRF token

      response.set_cooke(
        :jwt,
        {
          value: jwt,
          expires: 1.day.from_now,
          path: path,
          secure: secure,
          httponly: true
        }
      )
    end

    def warden
      context[:warden]
    end
  end
end
```
### Enums

```
// base_enum.rb

module Enums
  class BaseEnum < GraphQL::Schema::Enum
  end
end
```

```
// payment_method_enum.rb

module Enums
  class PaymentMethodEnum < BaseEnum
    CREDIT_CARD: 'CREDIT_CARD'.freeze
    INVOICE: 'INVOICE'.freeze

    value CREDIT_CARD, 'The payment method is credit card'
    value INVOICE, 'The payment method is invoice'
  end
end
```

```
// job_type_enum.rb

module Enums
  class JobTypeEnum < BaseEnum
    value Enums::Constants::DIRECT, 'The job will be pinged directly to the community', value: true
    value Enums::Constants::SELECT, 'The Weployer will be given a choice from a shortlist of Weployees', value: false
  end
end
```

```
// user_type_enum.rb

module Enums
  class UserTypeEnum < BaseEnum
    value Enums::Constants::AdminUser, 'Admin User type'
    value Enums::constants::User, 'Weployer or Weployee type'
  end
end
```

```
// constants.rb

module Enums
  class Constants
    # User Types
    ADMIN_USER: 'ADMIN_USER'.freeze
    USER: 'USER'.freeze

    # Job types
    DIRECT: 'DIRECT'.freeze
    SELECT: 'SELECT'freeze
  end
end
```

### Errors

```
// base_error_object.rb

module Objects
  module Errors
    class BaseErrorObject < GraphQL::ExecutionError
      def to_h
        super.merge(type: type)
      end

      def type
        raise NotImplementedError, 'Subclass did not define method #type for BaseErrorObject'
      end
    end
  end
end
```

```
// constants.rb

module Objects
  module Errors
    module Constants
      INVALID = 'INVALID'.freeze
      UNAUTHORIZED = 'UNAUTHORIZED'.freeze
    end
  end
end
```

```
// unauthorized_error_object.rb

module Objects
  module Errors
    class UnauthorizedErrorObject < BaseErrorObject
      def type
        Object::Errors::Constants::UNAUTHORIZED
      end
    end
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
