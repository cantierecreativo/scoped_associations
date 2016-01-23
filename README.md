# ScopedAssociations

[![Build Status](https://travis-ci.org/stefanoverna/scoped_associations.png?branch=master)](https://travis-ci.org/stefanoverna/scoped_associations)
[![Coverage Status](https://coveralls.io/repos/stefanoverna/scoped_associations/badge.png?branch=master)](https://coveralls.io/r/stefanoverna/scoped_associations?branch=master)

ScopedAssociations is able to create multiple `has_to` and `has_many`
associations between two ActiveRecord models.

## Installation
Scoped Association works on Rails4+

Add this line to your application's Gemfile:

    gem 'scoped_associations'
    
If you need it on a Rails3.2 project (without .joins support), add this one:

	gem 'scoped_association', '0.0.5'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoped_associations

## Usage

Just add `scoped: true` to your relation macro:

```
class Post < ActiveRecord::Base
  has_one :primary_tag,
    as: :owner,
    class_name: "Tag",
    scoped: true

  has_many :primary_tags,
    as: :owner,
    class_name: "Tag",
    scoped: true
end

## Running tests

Install gems:

```
$ bundle
$ bundle exec appraisal
```

Launch tests:

```
bundle exec appraisal rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

