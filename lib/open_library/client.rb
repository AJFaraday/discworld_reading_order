class OpenLibrary::Client
  #https://openlibrary.org/works/OL45804W.json
  def get_book(id)
    response = HTTParty.get("https://openlibrary.org/works/#{id}.json")
    OpenLibrary::Book.new(response.parsed_response)
  end

  # https://covers.openlibrary.org/b/id/$value-S.jpg
  # Sizes: "S", M", "L"
  def get_cover(id, size: "S")
    HTTParty.get(
      "https://covers.openlibrary.org/b/id/#{id}-#{size.upcase}.jpg"
    )
  end

  def get_works_page(author_id_or_url)
    url = if author_id_or_url.include?("works.json")
      "https://openlibrary.org#{author_id_or_url}"
    else
      "https://openlibrary.org/authors/#{author_id_or_url}/works.json"
    end

    OpenLibrary::WorksPage.new(HTTParty.get(url).parsed_response)
  end
end
