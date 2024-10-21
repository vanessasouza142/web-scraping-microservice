class ScrapedData < ApplicationRecord

  validates_presence_of :brand, :model, :price
end
