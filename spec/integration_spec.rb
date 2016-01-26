require 'spec_helper'

describe 'ScopedAssociations' do
  let(:post) { Post.new }

  context "non polymorphic" do

    describe "has_one" do
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
    end

    describe "has_many" do
      it "works with direct assignment" do
        post.secondary_comments = [ Comment.new(comment: "foo") ]
        post.save!

        post.reload
        expect(post.secondary_comments.size).to eq 1
        expect(post.primary_comments.size).to eq 0
      end

      it "works with <<" do
        post.save
        post.secondary_comments << Comment.new(comment: "foo")

        post.reload
        expect(post.secondary_comments.size).to eq 1
        expect(post.primary_comments.size).to eq 0
      end

      it "works with .build" do
        post.secondary_comments.build(comment: "foo")
        post.save

        post.reload
        expect(post.secondary_comments.size).to eq 1
        expect(post.primary_comments.size).to eq 0
      end

      it "works with nested attributes" do
        post = Post.new(primary_comments_attributes: [ { comment: "foo" } ])
        post.save!
        post.reload

        expect(post.primary_comments.size).to eq 1
        expect(post.secondary_comments.size).to eq 0
      end
    end

    describe "using more relation" do
      before do
        post.primary_comment = Comment.new(comment: "foo")
        post.primary_comments.build(comment: "bar")
        post.save!
        post.reload
      end

      it "has one element" do
        expect(post.primary_comment).to be_present
      end

      it "has many has 1 elements" do
        expect(post.primary_comments.size).to eq(1)
      end

      it "not contain the has_one element inside has_many elements" do
        expect(post.primary_comments).to_not include(post.primary_comment)
      end
    end
  end

  context "polymorphic" do
    describe "has_one" do
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
    end

    describe "has_many" do
      it "works with direct assignment" do
        post.secondary_tags = [ Tag.new(name: "foo") ]
        post.save!

        post.reload
        expect(post.secondary_tags.size).to eq 1
        expect(post.primary_tags.size).to eq 0
      end

      it "works with <<" do
        post.save
        post.secondary_tags << Tag.new(name: "foo")

        post.reload
        expect(post.secondary_tags.size).to eq 1
        expect(post.primary_tags.size).to eq 0
      end

      it "works with .build" do
        post.secondary_tags.build(name: "foo")
        post.save

        post.reload
        expect(post.secondary_tags.size).to eq 1
        expect(post.primary_tags.size).to eq 0
      end

      it "works with nested attributes" do
        post = Post.new(primary_tags_attributes: [ { name: "foo" } ])
        post.save!
        post.reload

        expect(post.primary_tags.size).to eq 1
        expect(post.secondary_tags.size).to eq 0
      end
    end

    describe "using more relation" do
      before do
        post.primary_tag = Tag.new(name: "foo")
        post.primary_tags.build(name: "bar")
        post.save!
        post.reload
      end

      it "has one element" do
        expect(post.primary_tag).to be_present
      end

      it "has many has 1 elements" do
        expect(post.primary_tags.size).to eq(1)
      end

      it "not contain the has_one element inside has_many elements" do
        expect(post.primary_tags).to_not include(post.primary_tag)
      end
    end
  end
end
