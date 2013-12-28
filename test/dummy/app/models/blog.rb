class Blog < ActiveRecord::Base
  acts_as_markable
  acts_as_markable_by :favorite_users
end
