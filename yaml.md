```ruby
# example.rb

def get_data(data_file)
  begin
    YAML::load_file(data_file)
  rescue => e
    raise "Error reading #{data_file}: #{e}"
  end
end

def process(data_file)
  data = get_data(data_file)
  data['times'].each do |t|
    puts do_something(t)
  end
end

if $0 == __FILE__
  raise ArgumentError, "Usage: #{$0} <filename>" unless ARGV.length == 1
  process(ARGV[0])
end
```

```ruby
# times.yml

---
times:
- 10h 3m
- 2h 5m
- 40m

```

Run the program passing in YAML data
```ruby
$ ./bin/example.rb spec/fixtures/times.yml

# => 36180
# => 7500
# => 2400
```
