# rails_event_logger

rails_event_logger is a simple gem which adds some methods to create history
entries for anything u want to record.

It doesnt keep an eye on the rails callbacks. You have to call the
logging method by yourself.

At the moment this gem supports only ActiveRecord ORM

## Installation

Add this line to your application's Gemfile:

    gem 'rails_event_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_event_logger

After bundle or installation execute the following shell commands:
```bash
$ rails generate rails_event_logger:install
$ rake db:migrate
```


## Usage

Add `has_event_logging` on your models:

```ruby
class Post < ActiveRecord::Base
  has_event_logging
end
```

This adds a `logs` class method and the `log_event` and `logs` instance methods to
your model.

The `log_event` method needs a `logged_changes` attribute which is a
serialized field in the database. So u can save Hashes with anything u
want.

```ruby
p = Post.create(text: "Hello World!") # => <Post id: 1, text: "Hello World!">

p.log_event(logged_changes: {msg: "Something happend what i want to log in my event_logs table"})
# => <RailsEventLogger::Models::EventLog id: 1, logged_changes: {:msg=>"Something happend what i want to log in my event_logs table"}, ...>

p2 = Post.create(text: "Lorem") # => <Post id: 2, text: "Lorem">

p2.log_event(logged_changes: {msg: "A simple log entry for post 2"})
# => <RailsEventLogger::Models::EventLog id: 2, logged_changes: {:msg=>"A simple log entry for post 2"}, ...>

Post.logs # => [<RailsEventLogger::Models::EventLog id: 1,...>, <RailsEventLogger::Models::EventLog id: 2,...>>]

# All the log entries for post p
p.logs # =>  [#<RailsEventLogger::Models::EventLog id: 1, item_id: 1...>]

log_entry = Post.logs.first # =>  <RailsEventLogger::Models::EventLog id: 1, logged_changes: {:msg=>"Something happend what i want to log in my event_logs table"}, ...>
log_entry.user # => Returns the user who was logged in when the event was logged, or the user with the stored id, if user_id was overwritten
```

The `log_event` method creates a record with ur given attributes and
sets the following attributes with default values.

* event_type
* item_id
* user_id
* created_at

The `event_type` is always set to `#{ModelClassName}EventLog}` by default, but can be overwritten.

The `item_id` represents the ID of the Model instance on which you called the
`log_event` method unless u overwrite it on the method call.

The `user_id` is set to the return value of the current_user method if
`log_event` is called from an controller. If not it will be nil unless
u overwrite it on the method call.

```ruby
product = Product.last # => <Product id: 42, name: "Test">

u.log_event(item_id: product.id logged_changes: {msg: "Something... "})
# => <RailsEventLogger::Models::EventLog id: 2, item_id: 42, logged_changes: {:msg=>"Something happend what i want to log in my event_logs table"}>
```

## Contributing

1. Fork it ( http://github.com/th1988/rails_event_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
