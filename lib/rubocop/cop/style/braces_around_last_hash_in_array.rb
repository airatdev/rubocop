# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      class BracesAroundLastHashInArray < Cop
        MSG = '%<type>s curly braces around the last hash parameter in array.'.freeze

        def on_send(node)
          return unless node.square_brackets?

          # TODO
        end
      end
    end
  end
end
