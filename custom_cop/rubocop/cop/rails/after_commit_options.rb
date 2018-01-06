require 'rubocop'

module RuboCop
  module Cop
    module Rails
      class AfterCommitOptions < Cop
        NO_OPTIONS_MESSAGE = 'Add :on or :if/:unless option'.freeze
        BROAD_ON_MESSAGE = 'Add :if/:unless modifier or limit :on variants'.freeze

        def_node_matcher :after_commit?, <<-PATTERN
          (send _ :after_commit ...)
        PATTERN

        def_node_matcher :blank_options?, <<-PATTERN
          (!hash ...)
        PATTERN

        def_node_matcher :broad_on?, <<-PATTERN
          (hash (pair (sym :on) $array))
        PATTERN

        def on_send(node)
          return unless after_commit?(node)
          options = node.children.last

          add_offense(node, message: NO_OPTIONS_MESSAGE) if blank_options?(options)
          add_offense(node, message: BROAD_ON_MESSAGE)   if broad_on_options?(options)
        end

        private

        def broad_on_options?(options)
          on_node = broad_on?(options)
          return false if on_node.nil?
          all_on_options_passed?(on_node)
        end

        def all_on_options_passed?(node)
          options_keys = node.values.map(&:node_parts).flatten

          (%i[create update destroy] - options_keys).empty?
        end
      end
    end
  end
end
