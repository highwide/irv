# frozen_string_literal: true

RSpec.describe Irv::Result do
  let(:result) { Irv::Result.new(candidates, ballots) }
  let(:candidates) { %w(a b c) }
  let(:ballots) do
    [
      %w(a b c),
      %w(a c b),
      %w(b a c),
      %w(b c a),
      %w(c b a)
    ]
  end

  # Round 1
  # (a b c)
  # (a c b)
  # (b a c)
  # (b c a)
  # (c b a)
  # tally => [{a: 2, b: 2, c: 1}, {a: 1, b: 2, c: 2}, {a: 2, b: 1, c: 2}]
  # loser => 'c'
  #
  # Round 2
  # (a b)
  # (a b)
  # (b a)
  # (b a)
  # (b a)
  # tally => [{a: 2, b: 3 }, {a: 3, b: 2 }]
  # winner => 'b'
  #
  describe '#initialize' do
    let(:process) { result.process }

    it 'has a process made with two rounds' do
      aggregate_failures do
        expect(process.count).to eq 2

        first_round = process[0]
        expect(first_round.order).to eq 1
        expect(first_round.majority).to be_nil
        expect(first_round.loser).to eq 'c'

        second_round = process[1]
        expect(second_round.order).to eq 2
        expect(second_round.majority).to eq 'b'
        expect(second_round.loser).to be_nil
      end
    end
  end

  describe '#winner' do
    subject { result.winner }

    it { is_expected.to eq 'b' }

    context 'when the process ends in a tie' do
      let(:candidates) { %w(a b) }
      let(:ballots) do
        [
          %w(a b),
          %w(b a)
        ]
      end

      it { is_expected.to eq('a').or eq('b') }
    end
  end
end
