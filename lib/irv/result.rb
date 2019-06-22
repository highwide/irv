# frozen_string_literal: true

require 'irv/round'

module Irv
  class Result
    attr_reader :process

    def initialize(candidates, ballots)
      @process = []
      round_order = 1
      round = Round.new(round_order, candidates, ballots.map(&:ranked_candidates))
      while !round.exist_majority?
        @process << round
        round_order += 1
        round = Round.new(round_order, round.next_candidates, round.next_votes)
      end
      @process << round
    end

    def winner
      @process.last.majority
    end
  end
end
