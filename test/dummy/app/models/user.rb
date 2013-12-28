class User < ActiveRecord::Base
  acts_as_marker
  acts_as_marker_on :favorite_blogs
  acts_as_marker_on :favorite_posts
  acts_as_marker_on :read_posts
end
