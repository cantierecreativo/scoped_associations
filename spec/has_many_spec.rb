require 'spec_helper'

describe 'ScopedAssociations' do
  let(:post) { Post.new(title: "A title") }

  describe "not polymorphic has_many" do
    it "works with direct assignment" do
      post.secondary_comments = [ Comment.new(comment: "foo") ]
      post.save!

      post.reload
      expect(post.secondary_comments).to be_present
      expect(post.primary_comments).to be_blank
    end

    it "works with nested attributes" do
      post = Post.new(primary_comments_attributes: [ { comment: "foo" } ])
      post.save!
      post.reload

      expect(post.primary_comments).to be_present
      expect(post.secondary_comments).to be_blank
    end

    it "works with .build" do
      post.secondary_comments.build(comment: "foo")
      post.save

      post.reload
      expect(post.secondary_comments).to be_present
      expect(post.primary_comments).to be_blank
    end

    it "works with .create" do
      post.save!
      post.primary_comments.create(comment: "foo")
      post.reload

      expect(post.primary_comments).to be_present
      expect(post.secondary_comments).to be_blank
    end

    it "works with .joins" do
      post.save!
      post.primary_comments.create(comment: "foo")
      post.reload

      expect(Post.joins(:primary_comments)).to be_present
      expect(Post.joins(:secondary_comments)).to be_blank
    end

    it "works with <<" do
      post.save
      post.secondary_comments << Comment.new(comment: "foo")

      post.reload
      expect(post.secondary_comments).to be_present
      expect(post.primary_comments).to be_blank
    end

    it "works with additional scope" do
      post.save!

      post.active_comments.create(comment: "foo")
      post.primary_comments.create(comment: "bar", active: false)
      post.secondary_comments.create(comment: "baz", active: true)

      post.active_comments.update_all(active: false)
      post.reload

      expect(post.active_comments).to be_blank
    end
  end
end
