class Post < ActiveRecord::Base
  acts_as_markable
  acts_as_markable_by :favorite_users
  acts_as_markable_by :read_users
end
