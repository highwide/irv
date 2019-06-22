# frozen_string_literal: true

require 'irv/ballot'
require 'irv/result'

module Irv
  class Election
    attr_reader :candidates

    def initialize(candidates)
      @candidates = candidates
      @ballots = []
    end

    def issue_ballot
      Ballot.new(@candidates)
    end

    def poll!(ballot)
      @ballots << ballot
    end

    def result
      return nil if @ballots.empty?

      Result.new(@candidates.map(&:to_s), @ballots)
    end

    def winner
      result&.winner
    end
  end
end
