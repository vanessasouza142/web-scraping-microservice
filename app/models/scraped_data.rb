class ScrapedData < ApplicationRecord

  validates_presence_of :task_id, :task_url, :brand, :model, :price
  
end
