# frozen_string_literal: true

RSpec.describe Irv::Election do
  let(:election) { Irv::Election.new(candidates) }
  let(:candidates) { %w(a b c) }

  describe '#poll!' do
    subject { election.poll!(ranked_candidates) }
    let(:ranked_candidates) { %w(c b a) }

    context 'when candidates has incorrect one' do
      let(:ranked_candidates) { %w(a b d) }

      it { expect { subject }.to raise_error(Irv::PollingWithIncorrectCandidatesError) }
    end

    context 'when candidates are duplicated' do
      let(:ranked_candidates) { %w(a a b) }

      it { expect { subject }.to raise_error(Irv::PollingWithIncorrectCandidatesError) }
    end

    it 'assigns ranked_candidates to instance variable' do
      expect(subject.instance_variable_get(:@ballots)).to eq [ranked_candidates]
    end
  end

  describe '#result' do
    subject(:result) { election.result }

    context 'when election is polled' do
      before { election.poll!(%w(c b a)) }

      it { expect(result.winner).to eq 'c' }
    end

    context 'when election is not polled' do
      let(:election) { Irv::Election.new(candidates) }

      it { is_expected.to be_nil }
    end
  end

  describe '#winner' do
    subject { election.winner }

    context 'when election is polled' do
      before { election.poll!(%w(c b a)) }

      it { is_expected.to eq 'c' }
    end

    context 'when election is not polled' do
      let(:election) { Irv::Election.new(candidates) }

      it { is_expected.to be_nil }
    end
  end
end
