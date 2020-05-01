module Magic::Link
  class Token < ApplicationRecord
    validates :token, uniqueness: { scope: :resource_id }

  end
end
