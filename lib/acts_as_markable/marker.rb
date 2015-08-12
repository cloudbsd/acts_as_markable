module ActsAsMarkable
  module Marker
    module Methods
      extend ActiveSupport::Concern

      self.included do
      end

      module ClassMethods
        def is_marker?
          true
        end
      end # module ClassMethods

      def mark?(markable, action = nil)
        self.marks.exists?(markable: markable, action: action)
      end

      def mark(markable, action = nil)
        self.marks.create(markable: markable, action: action)
      end

      def unmark(markable, action = nil)
        self.marks.where(markable: markable, action: action).destroy_all
      end
    end # module Methods
  end # module Marker
end # module ActsAsMarkable
