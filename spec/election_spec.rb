# frozen_string_literal: true

RSpec.describe Irv::Election do
  let(:election) { Irv::Election.new(candidates) }
  let(:candidates) { %w(a b c) }

  describe '#issue_ballot' do
    subject(:ballot) { election.issue_ballot }

    it { expect(ballot.candidates).to eq candidates }
  end

  describe '#poll!' do
    before { election.poll!(ballot) }
    let(:ballot) { election.issue_ballot.tap { |b| b.fill!(%w(c b a)) } }

    it 'assigns ballot to instance variable' do
      expect(election.instance_variable_get('@ballots')).to eq [ballot]
    end
  end

  describe '#result' do
    subject(:result) { election.result }

    context 'when election is polled' do
      before do
        ballot = election.issue_ballot.tap { |b| b.fill!(%w(c b a)) }
        election.poll!(ballot)
      end

      it { expect(result.winner).to eq 'c' }
    end

    context 'when ballots are empty' do
      let(:election) { Irv::Election.new(candidates) }

      it { is_expected.to be_nil }
    end
  end

  describe '#winner' do
    subject { election.winner }

    context 'when election is polled' do
      before do
        ballot = election.issue_ballot.tap { |b| b.fill!(%w(c b a)) }
        election.poll!(ballot)
      end

      it { is_expected.to eq 'c' }
    end

    context 'when ballots are empty' do
      let(:election) { Irv::Election.new(candidates) }

      it { is_expected.to be_nil }
    end
  end
end
