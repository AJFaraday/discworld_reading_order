class Book < ApplicationRecord
  has_one_attached :thumbnail
  has_one_attached :cover
end
