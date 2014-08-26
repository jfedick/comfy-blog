class AddImageColumnsToPosts < ActiveRecord::Migration
  def self.up
    add_attachment :comfy_blog_posts, :image
  end

  def self.down
    remove_attachment :comfy_blog_posts, :image
  end
end
