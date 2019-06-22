# frozen_string_literal: true

RSpec.describe Irv::Ballot do
  let(:ballot) { Irv::Ballot.new(%w(a b c)) }

  describe '#fill!' do
    subject { ballot.fill!(ranked_candidates) }
    let(:ranked_candidates) { %w(c b a) }

    it 'assigns ranked candidates' do
      aggregate_failures do
        is_expected.to eq ranked_candidates
        expect(ballot.ranked_candidates).to eq %w(c b a)
      end
    end

    context 'when candidates has incorrect one' do
      let(:ranked_candidates) { %w(a b d) }

      it { expect { subject }.to raise_error(Irv::FillingWithIncorrectCandidatesError) }
    end

    context 'when candidates are duplicated' do
      let(:ranked_candidates) { %w(a a b) }

      it { expect { subject }.to raise_error(Irv::FillingWithIncorrectCandidatesError) }
    end
  end
end
