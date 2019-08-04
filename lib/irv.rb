# frozen_string_literal: true

require 'irv/version'
require 'irv/election'

module Irv
  module_function

  def new(candidates)
    Election.new(candidates)
  end

  class PollingWithIncorrectCandidatesError < StandardError; end
end
