# frozen_string_literal: true

module Irv
  class Round
    attr_reader :order, :majority, :loser

    def initialize(order, candidates, votes)
      @order = order
      @candidates = candidates
      @votes = votes
      @tallied_votes = tally(votes)
      @majority = calc_majority
      @loser = calc_loser
    end

    def exist_majority?
      return true if @majority

      false
    end

    def next_candidates
      return nil if exist_majority?

      @candidates.reject { |candidate| candidate == @loser }
    end

    def next_votes
      return nil if exist_majority?

      @votes.map do |votes_in_a_rank|
        votes_in_a_rank.reject { |candidate| candidate == @loser }
      end
    end

    private

    # input: [[A, B, C], [B, A], [A]]
    # output:
    #   [
    #     {A => 2 ,B => 1, C => 0}, # count of 1st ranked ballots
    #     {A => 1, B => 1, C => 0}, # count of 2nd ranked ballots
    #     {A => 1, B => 0, C => 0}  # count of 3rd ranked ballots
    #   ]
    def tally(votes)
      tallied_votes = []
      max_ranked_votes_count(votes).times do |n|
        nth_ranked_votes = votes.map { |vote| vote[n] }
        tallied_votes << @candidates.each_with_object({}) { |candidate, hash| hash[candidate.to_sym] = nth_ranked_votes.count(candidate) }
      end
      tallied_votes
    end

    def max_ranked_votes_count(votes)
      votes.max(&:count).count
    end

    def calc_majority
      candidate, count = @tallied_votes.first.max_by { |_, v| v }
      return candidate.to_s if count / @votes.count.to_f > 0.5

      nil
    end

    def calc_loser
      return nil if exist_majority?

      target_candidates = @tallied_votes.first.keys

      @tallied_votes.each do |tallied_votes_in_a_rank|
        target_candidates_with_count = tallied_votes_in_a_rank.select { |k, _| target_candidates.include?(k) }

        min_vote_count = target_candidates_with_count.values.min
        min_voted_candidates = target_candidates_with_count.select { |_, v| v == min_vote_count }.keys

        return min_voted_candidates.first.to_s if min_voted_candidates.count == 1

        target_candidates = min_voted_candidates
      end

      # if last ranked votes can't decide loser, choose it at random
      target_candidates.sample
    end
  end
end
