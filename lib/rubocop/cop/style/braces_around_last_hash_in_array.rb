# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # @example EnforcedStyle: no_braces (default)
      class BracesAroundLastHashInArray < Cop
        include ConfigurableEnforcedStyle
        include RangeHelp

        MSG = '%<type>s curly braces around a hash parameter in array.'.freeze

        def on_send(node)
          return unless node.square_brackets?

          # return unless node.arguments? && node.last_argument.hash_type? &&
          #               !node.last_argument.empty?

          # check(node.last_argument, node.arguments)
        end

        private

        def check(arg, args)
          if style == :braces && !arg.braces?
            add_arg_offense(arg, :missing)
          elsif style == :no_braces && arg.braces?
            add_arg_offense(arg, :redundant)
          elsif style == :context_dependent
            check_context_dependent(arg, args)
          end
        end

        def check_context_dependent(arg, args)
          braces_around_second_from_end = args.size > 1 && args[-2].hash_type?

          if arg.braces?
            unless braces_around_second_from_end
              add_arg_offense(arg, :redundant)
            end
          elsif braces_around_second_from_end
            add_arg_offense(arg, :missing)
          end
        end

        def add_arg_offense(arg, type)
          add_offense(arg.parent, location: arg.source_range,
                                  message: format(MSG,
                                                  type: type.to_s.capitalize))
        end

        def extra_space(hash_node)
          {
            newlines: extra_left_space?(hash_node) &&
              extra_right_space?(hash_node),
            left: extra_left_space?(hash_node),
            right: extra_right_space?(hash_node)
          }
        end

        def extra_left_space?(hash_node)
          @extra_left_space ||= begin
            top_line = hash_node.source_range.source_line
            top_line.delete(' ') == '{'
          end
        end

        def extra_right_space?(hash_node)
          @extra_right_space ||= begin
            bottom_line_number = hash_node.source_range.last_line
            bottom_line = processed_source.lines[bottom_line_number - 1]
            bottom_line.delete(' ') == '}'
          end
        end
      end
    end
  end
end
