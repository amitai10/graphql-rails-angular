class Company < ActiveRecord::Base
    has_many :customers
end
