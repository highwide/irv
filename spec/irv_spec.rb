# frozen_string_literal: true

RSpec.describe Irv do
  describe '#new' do
    subject(:election) { Irv.new(candidates) }

    let(:candidates) { %w(a b c) }

    it { expect(election.candidates).to eq candidates }
  end

  describe 'example from README' do
    it 'expect that George wins' do
      irv = Irv.new(['John', 'Paul', 'Ringo', 'George'])

      irv
        .poll!(['John', 'George', 'Ringo'])
        .poll!(['John', 'Ringo', 'George', 'Paul'])
        .poll!(['Paul', 'George', 'Ringo', 'John'])
        .poll!(['Ringo', 'Paul', 'George'])
        .poll!(['George', 'Ringo', 'John'])

      expect(irv.winner).to eq 'George'
    end
  end
end
