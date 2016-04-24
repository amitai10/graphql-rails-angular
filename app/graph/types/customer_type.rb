CustomerType = GraphQL::ObjectType.define do
  name "Customer"
  description "A customer of a company"

  # Expose fields associated with Customer model
  field :id, types.ID, "This id of this customer"
  field :name, types.String, "The name of the customer"
  field :email, types.String, "The email of the customer"
  field :company_id, types.ID, "The customer's company"
  field :address, AddressType
end
