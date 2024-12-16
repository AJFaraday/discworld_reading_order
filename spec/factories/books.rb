FactoryBot.define do
  factory :book do
    title { "The Colour of Magic" }
    description { "The first book" }
    thumbnail do
      Rack::Test::UploadedFile.new(
        "spec/assets/colour_of_magic.jpg",
        "image/png"
      )
    end
  end
end
