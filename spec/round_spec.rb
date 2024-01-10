# frozen_string_literal: true

RSpec.describe Irv::Round do
  let(:round) { Irv::Round.new(order, candidates, votes) }
  let(:order) { 1 }

  context 'When majority exists' do
    let(:candidates) { %w(a b c d) }
    let(:votes) do
      [
        %w(a b c),
        %w(a c b),
        %w(b c)
      ]
    end

    describe '#initialize' do
      it 'has a majority / does not have a loser' do
        aggregate_failures do
          expect(round.order).to eq 1
          expect(round.instance_variable_get('@tallied_votes')).to eq [
            { a: 2, b: 1, c: 0, d: 0 },
            { a: 0, b: 1, c: 2, d: 0 },
            { a: 0, b: 1, c: 1, d: 0 }
          ]
          expect(round.majority).to eq 'a'
          expect(round.loser).to be_nil
        end
      end
    end

    describe '#exist_majority?' do
      subject { round.exist_majority? }

      it { is_expected.to eq true }
    end

    describe '#next_candidates' do
      subject { round.next_candidates }

      it { is_expected.to eq nil }
    end

    describe '#next_votes' do
      subject { round.next_votes }

      it { is_expected.to eq nil }
    end
  end

  context 'When majority does not exists' do
    let(:candidates) { %w(a b c) }
    let(:votes) do
      [
        %w(a b c),
        %w(b a c),
        %w(c a)
      ]
    end

    describe '#initialize' do
      it 'does not have a majority / has a loser' do
        aggregate_failures do
          expect(round.order).to eq 1
          expect(round.instance_variable_get('@tallied_votes')).to eq [
            { a: 1, b: 1, c: 1 },
            { a: 2, b: 1, c: 0 },
            { a: 0, b: 0, c: 2 }
          ]
          expect(round.majority).to be_nil
          expect(round.loser).to eq 'c'
        end
      end
    end

    describe '#exist_majority?' do
      subject { round.exist_majority? }

      it { is_expected.to eq false }
    end

    describe '#next_candidates' do
      subject { round.next_candidates }

      it { is_expected.to eq %w(a b) }
    end

    describe '#next_votes' do
      subject { round.next_votes }

      it {
        is_expected.to eq [
          %w(a b),
          %w(b a),
          %w(a)
        ]
      }
    end
  end
end
