# frozen_string_literal: true

module Irv
  class Ballot
    attr_reader :candidates, :ranked_candidates

    def initialize(candidates)
      @candidates = candidates
      @ranked_candidates = []
    end

    def fill!(ranked_candidates)
      unless correct_candidates?(ranked_candidates)
        raise(
          FillingWithIncorrectCandidatesError,
          "Filling #{ranked_candidates}, but acceptable for only #{@candidates}"
        )
      end

      @ranked_candidates = ranked_candidates
    end

    private

    def correct_candidates?(ranked_candidates)
      ranked_candidates.all? { |c| @candidates.include?(c) } &&
        (ranked_candidates.count == ranked_candidates.uniq.count)
    end
  end
end
