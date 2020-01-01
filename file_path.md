# `$LOAD_PATH` Environment Variable
`$LOAD_PATH` is an array of string paths, each of which is a directory on your computer where Ruby files are stored.
If you use `require` anywhere in your applicationthen Ruby will look for a Ruby file with the same name in each of these directories.
It will load the first file with this name that it can find.

```ruby
ruby -e 'puts $LOAD_PATH'

/Users/Josh/.asdf/plugins/ruby/rubygems-plugin
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/gems/2.6.0/gems/did_you_mean-1.3.0/lib
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/site_ruby/2.6.0
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/site_ruby/2.6.0/x86_64-darwin18
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/site_ruby
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/vendor_ruby/2.6.0
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/vendor_ruby/2.6.0/x86_64-darwin18
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/vendor_ruby
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/2.6.0
/Users/Josh/.asdf/installs/ruby/2.6.1/lib/ruby/2.6.0/x86_64-darwin18
```

# Find root Directory name with `File.dirname(__FILE__)`

This will return the name of the current, or root directory depending on where the code is being executed from.

`File.dirname(__File__)` corresponds to the root directory for `__FILE__`, which in turn corresponds to the relative path to the current file. For example if you have a file `parent_dir/sub_dir/printer.rb` that contains:

```
puts File.dirname(__FILE__)
```

If you are in `parent_dir` and run `ruby sub_dir/printer.rb`, you will get `=> sub_dir`. However if you `cd` into `sub_dir` and run `ruby printer.rb`, you will get `=> .` instead.

# Finding the absolute path with `File.expand_path` method

To get the absolute path to a file (as opposed to the relative path using `dirname`), you need to use `expand_path`.

`File.expand_path('../../Gemfile', __FILE__)`

This is how it works:

`File.expand_path` resolves the absolute path of the first argument, relative to the second argument `__FILE__` (which defaults to the current working file directory unless `dir_string` is given, in which case it will be used as the starting point)

`__FILE__` is the relative path to the file the code is being run from.

Thus we are able to find the absolute path to whatever `__FILE__` is, relative to the location of the first argument.

This is commonly used to load files in a `lib` directory for example, and make them available to whatever `__FILE__` or `spec` needs them when the code runs.

The `__FILE__` variable is used to find the exact location of the file in which it is defined. This variable makes the code machine independent as the path of the source root folder `lib` is evaluated relative to the path of the file`(__FILE__)`.

```ruby
# Suppose we are in bin/mygem and want the absolute path of lib/mygem.rb.

File.expand_path("../../lib/mygem.rb", __FILE__)
#=> ".../path/to/project/lib/mygem.rb"

```
The above example first resolves the parent of `__FILE__`, that is `bin/`, then goes to the parent, the root of the project and appends `lib/mygem.rb`.

## Adding a new `PATH` to `$LOAD_PATH`


```ruby
# Add the absolute path to `$LOAD_PATH` to the `/lib` directory from `__FILE__`:

$LOAD_PATH.unshift(File.expand_path('../../lib/', __FILE__))
```

```ruby
# Add relative path to /lib to $LOAD_PATH (using dirname):

lib = File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
```

```ruby
# Add the absolute path to /lib to $LOAD_PATH (using expand_path):

lib = File.expand_path(“lib”, __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
```

## Using sugar-syntax `$:.`

`$LOAD_PATH` can also be written a `$:`

```ruby
$:.unshift(File.dirname(__FILE__))
```

```ruby
# Add the absolute path to __FILE__ to $FILE_PATH if $FILE_PATH doesn't already have the absolute or relative paths to that __FILE__:

$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
```



