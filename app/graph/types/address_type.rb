AddressType = GraphQL::ObjectType.define do
  name "Address"
  description "A customer address"

  # Expose fields associated with Address model
  field :id, types.ID, "This id of this address"
  field :city, types.String, "City"
  field :street, types.String, "Street"
  field :num, types.String, "House number"
  # field :customer_id, types.ID, "The Customer"
end
