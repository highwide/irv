# frozen_string_literal: true

RSpec.describe Irv do
  describe '#new' do
    subject(:election) { Irv.new(candidates) }

    let(:candidates) { %w(a b c) }

    it { expect(election.candidates).to eq candidates }
  end
end
