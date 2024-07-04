class Report < ApplicationRecord
    class Report < ApplicationRecord
        belongs_to :product, primary_key: 'id_product', foreign_key: 'id_product', optional: true
    end

end