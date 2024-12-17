class OpenLibrary::Client
  #https://openlibrary.org/works/OL45804W.json
  def get_book(id)
    response = HTTParty.get("https://openlibrary.org/works/#{id}.json")
    OpenLibrary::Book.new(response)
  end

  # https://covers.openlibrary.org/b/id/$value-S.jpg
  # Sizes: "S", M", "L"
  def get_cover(id, size: "S")
    HTTParty.get(
      "https://covers.openlibrary.org/b/id/#{id}-#{size.upcase}.jpg"
    )
  end
end
