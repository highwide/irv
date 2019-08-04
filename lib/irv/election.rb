# frozen_string_literal: true

require 'irv/result'

module Irv
  class Election
    attr_reader :candidates

    def initialize(candidates)
      @candidates = candidates
      @ballots = []
    end

    def poll!(ranked_candidates)
      if incorrect_candidates?(ranked_candidates)
        raise(
          PollingWithIncorrectCandidatesError,
          "Polling #{ranked_candidates}, but acceptable for only #{@candidates}"
        )
      end

      @ballots << ranked_candidates
      self
    end

    def result
      return nil if @ballots.empty?

      Result.new(@candidates.map(&:to_s), @ballots)
    end

    def winner
      result&.winner
    end

    private

    def incorrect_candidates?(ranked_candidates)
      ranked_candidates.class != Array ||
        ranked_candidates.count - ranked_candidates.uniq.count != 0 ||
        ranked_candidates.any? { |c| !@candidates.include?(c) }
    end
  end
end
