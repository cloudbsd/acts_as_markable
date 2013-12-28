module ActsAsMarkable
  class Mark < ActiveRecord::Base
    belongs_to :markable, :polymorphic => true
    belongs_to :marker, :polymorphic => true

    validates :markable, presence: true
    validates :marker, presence: true
    validates :action, presence: true
  end
end
