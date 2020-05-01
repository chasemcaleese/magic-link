module Magic::Link
  class Token < ApplicationRecord
    validates :token, uniqueness: { scope: :resource_id }

    belongs_to :resource, class_name: Magic::Link.user_class.to_s
  end
end
