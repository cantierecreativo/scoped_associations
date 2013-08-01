require 'rubygems'
require 'bundler'
require 'active_record'
require 'logger'
require 'coveralls'
Coveralls.wear!

ROOT = File.expand_path('../', __FILE__)

require 'scoped_associations'

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
  end

  create_table :posts do |t|
    t.string :title
  end

  create_table :comments do |t|
    t.integer  :post_id,    null: false
    t.string   :post_scope, null: false
    t.string   :comment,    null: false
  end
end

# ActiveRecord::Base.logger = Logger.new(STDOUT)

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

  has_one :secondary_tag, as: :owner,
                          class_name: "Tag",
                          scoped: true

  has_many :primary_tags, as: :owner,
                          class_name: "Tag",
                          scoped: true

  accepts_nested_attributes_for :primary_tags

  has_many :secondary_tags, as: :owner,
                            class_name: "Tag",
                            scoped: true


  has_one :primary_comment, class_name: "Comment",
                            scoped: true

  accepts_nested_attributes_for :primary_comment

  has_one :secondary_comment, class_name: "Comment",
                              scoped: true

  has_many :primary_comments, class_name: "Comment",
                              scoped: true

  accepts_nested_attributes_for :primary_comments

  has_many :secondary_comments, class_name: "Comment",
                              scoped: true
end

