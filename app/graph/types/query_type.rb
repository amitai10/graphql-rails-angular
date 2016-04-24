QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema. See available queries."

#   # Get Address by ID
#   # field :address, AddressType do
#   #   argument :id, !types.ID
#   #   description 'Root object to get viewer related collections'
#   #   resolve -> (obj, args, ctx) {
#   #     Address.find(args["id"])
#   #   }
#   # end
#
  field :company, CompanyType do
    argument :id, !types.ID
    description 'Root object to get viewer related collections'
    resolve -> (obj, args, ctx) {
      Company.find(args["id"])
    }
  end
#
#   field :company_customer do
#     type CompanyType
#     resolve -> (obj, args, context) { OpenStruct.new(id: 1) }
#   end
#
#   field :customer, CompanyType do
#     argument :id, !types.ID
#     description 'Root object to get viewer related collections'
#     resolve -> (obj, args, ctx) {
#       Company.find(args["id"])
#     }
#   end
#
#   field :node, field: NodeInterface.field
# end
end
