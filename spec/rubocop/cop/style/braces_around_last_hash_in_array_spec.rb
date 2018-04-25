# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style::BracesAroundLastHashInArray, :config do
  subject(:cop) { described_class.new(config) }

  shared_examples 'single line lists' do |extra_info|
    it 'accepts empty literal' do
      expect_no_offenses('VALUES = []')
    end
  end

  context 'with single line list of values' do
    context 'when EnforcedStyle is no_braces' do
      let(:cop_config) { { 'EnforcedStyleForMultiline' => 'no_braces' } }

      include_examples 'single line lists', ''
    end
  end
end
