`bundle exec rails active_storage:install`

```ruby
  # Post.rb
  has_image_attached :image
```

Active Storage provides the following helper methods:

- `attached?`
- `attach`

Therefore to attach an image submitted from a form:

```ruby
  # _form.html.erb

  <%= form.file :image, accept: 'image/jpeg,image/gif,image/png' %>
```

```ruby
  # posts_controller.rb

  def create
    @post = @user.posts.build(post_params)
    @post.image.attach(post_params[:image])
    @post.save
  end
```

### Validation

Use the `active_storage_validations` gem

```ruby
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: 'must be a valid image format (jpeg, gif, png)' },
                    size: { less_than: 5.megabytes, message: 'must be less than 5MB' }
```

## Image processing

`brew install image_magick`

`image_processing` and `mini_magick` gems

Then use the `variant` method provided by Active Storage to transform the image:

> This doesn't seem to work: `image.variant(resize_to_limit: [500, 500])`

`image.variant(resize: '500x500')`

Or call `combine_options` if you need to call multiple methods:

```ruby
post.image.variant(
  combine_options: {
    thumbnail: "#{size}x#{size}^",
    gravity: "center",
    extent: "#{size}x#{size}"
  }
)
```

The `variant` command will be called once, then cached for future calls.

As a handy shortcut, `MiniMagick::Image.new` also accepts an optional block which is used to `combine_options`:

```ruby
image = MiniMagick::Image.new("input.jpg") do |b|
  b.resize "250x200>"
  b.rotate "-90"
  b.flip
end
# the command gets executed
```

# Active Storage with AWS S3

Install the gem:

`  gem 'aws-sdk-s3', '~> 1.74', require: false`

1. Sign up for AWS
2. Create a user in IAM with 'programmatic access' and give them Administrator Access (attach existing policies directly)
3. After creating the user store the Access Key ID Secret Access Key in LastPass
4. Create a bucket with a unique name

In `production.rb` configure `active_storage` to use Amazon:

`config.active_storage.service = :amazon`

Store the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and `AWS_BUCKET` keys in Rails credentials (or Heroku Config vars).

Configure the amazon connection in `storage.yml` to use the keys:

```ruby
# with Rails credentials

amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: us-east-1
  bucket: your_own_bucket
```

```ruby
# with Heroku

amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET'] %>

# don't forget to reset Heroku database

heroku pg:reset database
heroku run rails db:migrate
heroku run rails db:seed
```
