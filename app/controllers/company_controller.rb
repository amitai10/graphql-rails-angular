class CompanyController < ApplicationController
  def graphql
    query_string = params[:query]
      #query_variables = ensure_hash(params[:variables] || {})
      result = CompanySchema.execute(query_string)
      render json: result
  end

  def index
  end
end
