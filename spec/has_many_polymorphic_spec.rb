require 'spec_helper'

describe 'ScopedAssociations' do
  let(:post) { Post.new(title: "A title") }

  describe "polymorphic has_many" do
    it "works with direct assignment" do
      post.secondary_tags = [ Tag.new(name: "foo") ]
      post.save!

      post.reload
      expect(post.secondary_tags).to be_present
      expect(post.primary_tags).to be_blank
    end

    it "works with nested attributes" do
      post = Post.new(primary_tags_attributes: [ { name: "foo" } ])
      post.save!
      post.reload

      expect(post.primary_tags).to be_present
      expect(post.secondary_tags).to be_blank
    end

    it "works with .build" do
      post.secondary_tags.build(name: "foo")
      post.save!
      post.reload

      expect(post.secondary_tags).to be_present
      expect(post.primary_tags).to be_blank
    end

    it "works with .create" do
      post.save!
      post.secondary_tags.create(name: "foo")

      post.reload
      expect(post.secondary_tags).to be_present
      expect(post.primary_tags).to be_blank
    end

    it "works with .joins" do
      post.save!
      post.primary_tags.create(name: "foo")
      post.reload

      expect(Post.joins(:primary_tags)).to be_present
      expect(Post.joins(:secondary_tags)).to be_blank
    end

    it "works with <<" do
      post.save
      post.secondary_tags << Tag.new(name: "foo")

      post.reload
      expect(post.secondary_tags).to be_present
      expect(post.primary_tags).to be_blank
    end

    it "works with additional scope" do
      post.save!

      post.active_tags.create(name: "foo")
      post.primary_tags.create(name: "bar", active: false)
      post.secondary_tags.create(name: "baz", active: true)

      post.active_tags.update_all(active: false)
      post.reload

      expect(post.active_tags).to be_blank
    end
  end
end
