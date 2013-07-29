require 'spec_helper'

describe 'DragonflyGallery' do
  let(:tag_name) { "Foobar" }
  let(:post) { Post.new }

  describe "has_one_image" do
    it "works with direct assignment" do
      post.secondary_tag = Tag.new(name: tag_name)
      post.save!
      post.reload

      expect(post.secondary_tag).to be_present
      expect(post.primary_tag).to be_nil
    end

    it "works with nested attributes" do
      post = Post.new(primary_tag_attributes: { name: tag_name })
      post.save!
      post.reload

      expect(post.primary_tag).to be_present
      expect(post.secondary_tag).to be_nil
    end

    it "works with .build" do
      post.build_secondary_tag(name: tag_name)
      post.save!
      post.reload

      expect(post.secondary_tag).to be_present
      expect(post.primary_tag).to be_nil
    end
  end

  describe "has_many_images" do
    it "works with direct assignment" do
      post.secondary_tags = [ Tag.new(name: tag_name) ]
      post.save!

      post.reload
      expect(post.secondary_tags.size).to eq 1
      expect(post.primary_tags.size).to eq 0
    end

    it "works with <<" do
      post.save
      post.secondary_tags << Tag.new(name: tag_name)

      post.reload
      expect(post.secondary_tags.size).to eq 1
      expect(post.primary_tags.size).to eq 0
    end

    it "works with .build" do
      post.secondary_tags.build(name: tag_name)
      post.save

      post.reload
      expect(post.secondary_tags.size).to eq 1
      expect(post.primary_tags.size).to eq 0
    end

    it "works with nested attributes" do
      post = Post.new(primary_tags_attributes: [ { name: tag_name } ])
      post.save!
      post.reload

      expect(post.primary_tags.size).to eq 1
      expect(post.secondary_tags.size).to eq 0
    end
  end
end

