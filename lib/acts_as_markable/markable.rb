module ActsAsMarkable
  module Markable
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_markable?
          true
        end
      end # module ClassMethods

      def mark_by?(marker, action)
        self.marks.exists?(marker: marker, action: action)
      end

      def mark_by(marker, action)
        self.marks.create(marker: marker, action: action)
      end

      def unmark_by(marker, action)
        self.marks.where(marker: marker, action: action).destroy_all
      # if actions.nil?
      #   self.marks.where(marker: marker).delete_all
      # else
      #   conditions = []
      #   actions.each do |act|
      #     conditions << "action = '#{act}'"
      #   end
      #   self.marks.where(marker: marker).where(conditions.join(" or ")).destroy_all
      # end
      end
    end # module Methods
  end # module Markable
end # module ActsAsMarkable
