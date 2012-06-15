class ApplicationController < ActionController::Base
  before_filter :set_access

  def set_access
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
