# https://edgeguides.rubyonrails.org/active_storage_overview.html

rails active_storage:install
# creates a migration file from the ActiveStorage Model template

rails db:migrate

add routes 
get show
get index
post create
> need redirect_to puppies_path for create

# set up relationship between Puppy model and active storage

has_one_attached :uploaded_image
# :uploaded_image can be anything references field in a form later
# symbol that is argument of the has_one_attached method call.

# add methods to puppies_controler
params.permit(:name, :age :uploaded_image) #uploaded image now also included

create Views
Form to create new puppy

<form action="<%= puppies_path %>" method="POST" enctype="multipart/form-data">
    <input type="hidden" value="<%= form_authenticity_token %>" name="authenticity_token" />
    <label>Name</label>
    <input type="text" name="name" />

    <label>Age</label>
    <input type="text" name="age" />

    <label>Puppy Image Upload</label>
    <input type="file" name="uploaded_image" accept="image/png, image/jpeg"/>
    <input type="submit" value="Create Puppy" />
</form>

# https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file
# Input Image File Type

# when uploading an image in a form
# default works for text, but form doesnt recognise urlencoded format, have to specify that the form is multipart/form-data
==> enctype="multipart/form-data"


#to show the uploaded_image, have to use an immage tag

<ul>
  <% @puppies.each do |puppy| %>
    <li><%= puppy.name %></li>
    <li><%= puppy.age %></li>
    <li><%= image_tag puppy.uploaded_image %></li>
  <% end %>
</ul>

# img tag, second argument can be class:
class: 'image-size'

puppy.scss file

.image-size {
  height: 500px;
}

making image optional
use control flow

TUTORIAL:
https://evilmartians.com/chronicles/rails-5-2-active-storage-and-beyond


By the way, if you want to attach a file to the existing model somewhere else in the controller code, here’s how you do it:
@post.image.attach(params[:image])

Attaching Multiple Images:

# app/controllers/posts_controller.rb
def post_params
  params.require(:post).permit(:title, :content, images: [])
end

<!-- app/views/posts/_form.html.erb -->
<div class="field">
  <%= form.label :images %>
  <%= form.file_field :images, multiple: true %>
</div>

<!-- app/views/posts/show.html.erb -->
<% if @post.images.attached? %>
<p>
  <strong>Images:</strong>
  <br>
  <% @post.images.each do |image| %>
    <%= image_tag(image) %>
  <% end %>
</p>
<% end %>
