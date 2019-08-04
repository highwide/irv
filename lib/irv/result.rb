# frozen_string_literal: true

require 'irv/round'

module Irv
  class Result
    attr_reader :process

    def initialize(candidates, ballots)
      @process = []
      round_order = 1
      round = Round.new(round_order, candidates, ballots)

      (candidates.count - 1).times do
        @process << round
        break if round.exist_majority?

        round_order += 1
        round = Round.new(round_order, round.next_candidates, round.next_votes)
      end
    end

    def winner
      @process.last.majority
    end
  end
end
