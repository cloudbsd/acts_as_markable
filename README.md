# Acts As Markable

This plugin provides a simple way to mark users actions.

- Allow any model to be marked.
- Allow any model to mark. In other words, marker do not have to come from a user, they can come from any model (such as a Group or Team).
- Provide an easy to mark/unmark syntax.

## Installation

### Rails 4+

Add this line to your application's Gemfile:

    gem 'acts_as_markable'
    gem 'acts_as_markable', :git => "https://github.com/cloudbsd/acts_as_markable.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_markable

### Database Migrations

    $ rails generate acts_as_markable:migration
    $ rake db:migrate

## Usage

### Markable Models

    example:
    you have User and Post models, you hope to add favorite feature

    add acts_as_marker
    acts_as_marker_on favorite_posts

    favorite, unfavorite, favorite? methods will be generated.

    name with '_' is NOT allowed


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
