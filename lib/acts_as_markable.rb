require 'active_support'
require 'active_model'
require 'active_record'

require "acts_as_markable/version"
require "acts_as_markable/mark"
require "acts_as_markable/marker"
require "acts_as_markable/markable"

module ActsAsMarkable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def acts_as_markable(options={})
      do_acts_as_markable(options)
    end

    # action_markers = :favorite_users
    #   names = favorite_users
    #   names[0] = favorite_users
    #   action_name = names[1] = 'favorite'
    #   names[2] = users
    #   action_marks = favorite_marks
    #   action_markers_marks = favorite_users_marks
    def acts_as_markable_by(action_markers, options={})
      do_acts_as_markable(options)

      if action_markers.present?
        names = /(.+?)_(.+)/.match(action_markers.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_marks = (action_name + '_marks').to_sym
        action_marker_marks = (names[0] + '_marks').to_sym

        has_many action_marker_marks, -> { where(action: action_name, marker_type: object_type) }, as: :markable, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'
        has_many action_marks, -> { where(action: action_name) }, as: :markable, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'
        has_many action_markers, through: action_marker_marks, source: :marker, source_type: object_type

        do_generate_markable_methods action_name
      end
    end # acts_as_markable_by

    def acts_as_marker(options={})
      do_acts_as_marker(options)
    end

    def acts_as_marker_on(action_markables, options={})
      do_acts_as_marker(options)

      if action_markables.present?
        names = /(.+?)_(.+)/.match(action_markables.to_s)
        action_name = names[1]
        object_type = names[2].singularize.camelize
        action_marks = (action_name + '_marks').to_sym
        action_markables_marks = (names[0] + '_marks').to_sym

        has_many action_markables_marks, -> { where(action: action_name, markable_type: object_type) }, as: :marker, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'
        has_many action_marks, -> { where(action: action_name) }, as: :marker, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'
        has_many action_markables, through: action_markables_marks, source: :markable, source_type: object_type

        do_generate_marker_methods action_name
      end
    end # acts_as_marker_on

    def do_generate_markable_methods(action_name)
      method_name = "#{action_name}_by?"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |marker|
          self.mark_by?(marker, action_name)
        end
      end

      method_name = "#{action_name}_by"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |marker|
          self.mark_by(marker, action_name)
        end
      end

      method_name = "un#{action_name}_by"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |marker|
          self.unmark_by(marker, action_name)
        end
      end

      method_name = "#{action_name}_by_count"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do
          self.marks.where(action: action_name).size
        end
      end
    end # do_generate_markable_methods

    def do_generate_marker_methods(action_name)
      method_name = "#{action_name}?"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |markable|
          self.mark?(markable, action_name)
        end
      end

      method_name = "#{action_name}"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |markable|
          self.mark(markable, action_name)
        end
      end

      method_name = "un#{action_name}"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do |markable|
          self.unmark(markable, action_name)
        end
      end

      method_name = "#{action_name}_count"
      unless self.respond_to? method_name.to_sym
        define_method(method_name) do
          self.marks.where(action: action_name).size
        end
      end
    end # do_generate_marker_methods

    def do_acts_as_markable(options={})
      unless self.is_markable?
        has_many :marks, {as: :markable, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'}.merge(options)
        include ActsAsMarkable::Markable::Methods
      end
    end

    def do_acts_as_marker(options={})
      unless self.is_marker?
        has_many :marks, {as: :marker, dependent: :destroy, class_name: 'ActsAsMarkable::Mark'}.merge(options)
        include ActsAsMarkable::Marker::Methods
      end
    end

    def is_markable?
      false
    end

    def is_marker?
      false
    end
  end # ClassMethods
end # ActsAsMarkable


ActiveRecord::Base.send :include, ActsAsMarkable
