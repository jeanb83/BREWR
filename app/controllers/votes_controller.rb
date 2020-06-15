class VotesController < ApplicationController

  def create
    @tastes = Vote.get_vote_tastes
    @tastes.each do |taste|
      instance_variable_set("@" + "vote_" + taste, Vote.new(votes_params))
    end
  end

  private

  def votes_params
    params.require("vote_#{taste}".to_sym).permit(:taste, :like)
  end

end
