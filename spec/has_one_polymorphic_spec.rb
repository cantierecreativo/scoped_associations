require 'spec_helper'

describe 'ScopedAssociations' do
  let(:post) { Post.new(title: "A title") }

  context "polymorphic has_one" do

    it "works with direct assignment" do
      post.secondary_tag = Tag.new(name: "foo")
      post.save!
      post.reload

      expect(post.secondary_tag).to be_present
      expect(post.primary_tag).to be_nil
    end

    it "works with nested attributes" do
      post = Post.new(primary_tag_attributes: { name: "foo" })
      post.save!
      post.reload

      expect(post.primary_tag).to be_present
      expect(post.secondary_tag).to be_nil
    end

    it "works with .build" do
      post.build_secondary_tag(name: "foo")
      post.save!
      post.reload

      expect(post.secondary_tag).to be_present
      expect(post.primary_tag).to be_nil
    end

    it "works with .create" do
      post.save!
      post.create_secondary_tag(name: "foo")
      post.reload

      expect(post.secondary_tag).to be_present
      expect(post.primary_tag).to be_nil
    end

    it "works with .joins" do
      post.save!
      post.create_secondary_tag(name: "foo")

      expect(Post.joins(:primary_tag)).to be_blank
      expect(Post.joins(:secondary_tag)).to be_present
    end

    it "works with additional scope" do
      post.active_tag = Tag.new(name: "foo", active: false)
      post.primary_tag = Tag.new(name: "bar", active: false)
      post.secondary_tag = Tag.new(name: "baz", active: true)

      post.save!
      post.reload

      expect(post.active_tag).to be_nil
    end
  end
end
