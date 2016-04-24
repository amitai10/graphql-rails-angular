CompanyType = GraphQL::ObjectType.define do
  name "Company"
  description "A Company"

  # Expose fields associated with Company model
  field :id, types.ID, "This id of this company"
  field :name, types.String, "The name of the company"
  field :customers, types[CustomerType]

  # connection :customers, CustomerType.connection_type do
  #   resolve -> (obj, args, context) { [ Customer.new(name: 'amitai') ]}
  # end
end
