class Customer < ActiveRecord::Base
  has_one :address
  belongs_to :company
end
