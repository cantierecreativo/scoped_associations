require 'spec_helper'

describe 'ScopedAssociations' do
  let(:post) { Post.new(title: "A title") }

  context "non polymorphic has_one" do
    it "works with direct assignment" do
      post.secondary_comment = Comment.new(comment: "foo")
      post.save!
      post.reload

      expect(post.secondary_comment).to be_present
      expect(post.primary_comment).to be_nil
    end

    it "works with nested attributes" do
      post = Post.new(primary_comment_attributes: { comment: "foo" })
      post.save!
      post.reload

      expect(post.primary_comment).to be_present
      expect(post.secondary_comment).to be_nil
    end

    it "works with .build" do
      post.build_secondary_comment(comment: "foo")
      post.save!
      post.reload

      expect(post.secondary_comment).to be_present
      expect(post.primary_comment).to be_nil
    end

    it "works with .create" do
      post.save!
      post.create_primary_comment(comment: "foo")
      post.reload

      expect(post.primary_comment).to be_present
      expect(post.secondary_comment).to be_nil
    end

    it "works with .joins" do
      post.save!
      post.create_secondary_comment(comment: "foo")

      expect(Post.joins(:primary_comment)).to be_blank
      expect(Post.joins(:secondary_comment)).to be_present
    end

    it "works with additional scope" do
      post.active_comment = Comment.new(comment: "foo", active: false)
      post.primary_comment = Comment.new(comment: "bar", active: false)
      post.secondary_comment = Comment.new(comment: "baz", active: true)
      post.save!
      post.reload

      expect(post.active_comment).to be_nil
    end
  end
end
