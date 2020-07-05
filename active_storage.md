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
