require 'rubygems'
require 'bundler'
require 'active_record'
require 'logger'
require 'coveralls'
require 'database_cleaner'

Coveralls.wear!

ROOT = File.expand_path('../', __FILE__)

require 'scoped_associations'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :tags do |t|
    t.integer  :owner_id,    null: false
    t.string   :owner_type,  null: false
    t.string   :owner_scope, null: false
    t.string   :name,        null: false
    t.boolean  :active,      null: false, default: false
  end

  create_table :posts do |t|
    t.string :title
  end

  create_table :comments do |t|
    t.integer  :post_id,    null: false
    t.string   :post_scope, null: false
    t.string   :comment,    null: false
    t.boolean  :active,     null: false, default: false
  end
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Tag < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end

class Post < ActiveRecord::Base
  has_one :primary_tag, as: :owner,
          class_name: "Tag",
          scoped: true

  accepts_nested_attributes_for :primary_tag

  has_one :active_tag,
          -> { where(active: true) },
          as: :owner,
          class_name: "Tag",
          scoped: true



  has_one :secondary_tag, as: :owner,
          class_name: "Tag",
          scoped: true

  has_many :primary_tags, as: :owner,
           class_name: "Tag",
           scoped: true

  accepts_nested_attributes_for :primary_tags

  has_many :active_tags,
           -> { where(active: true) },
           as: :owner,
           class_name: "Tag",
           scoped: true


  has_many :secondary_tags,
           as: :owner,
           class_name: "Tag",
           scoped: true

  has_many :comments

  has_one :primary_comment,
          class_name: "Comment",
          scoped: true

  has_one :active_comment,
          -> { where(active: true) },
          class_name: "Comment",
          scoped: true

  accepts_nested_attributes_for :primary_comment

  has_one :secondary_comment,
          class_name: "Comment",
          scoped: true

  has_many :primary_comments,
           class_name: "Comment",
           scoped: true

  has_many :active_comments,
           -> { where(active: true) },
           class_name: "Comment",
           scoped: true

  accepts_nested_attributes_for :primary_comments

  has_many :secondary_comments,
           class_name: "Comment",
           scoped: true
end
