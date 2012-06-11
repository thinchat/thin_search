class Api::V1::SearchesController < ApplicationController
  def show
    query = params[:query]

    if query
      results = Message.search query, :star => true
    else
      results = {}
    end

    render :json => results
  end
end
