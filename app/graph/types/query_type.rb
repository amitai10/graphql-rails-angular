QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema. See available queries."

  field :company, CompanyType do
    argument :id, !types.ID
    description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) {
      Company.find(args["id"])
    }
  end

  field :companies, types[CompanyType] do
  description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) {
      Company.all
    }
  end

end
