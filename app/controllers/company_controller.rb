class CompanyController < ApplicationController
  def graphql
    query_string = params[:query]
      result = CompanySchema.execute(query_string)
      render json: result
  end

  def index
  end
end
