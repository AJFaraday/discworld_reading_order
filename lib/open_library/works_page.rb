class OpenLibrary::WorksPage
  def initialize(parsed_response)
    @parsed_response = parsed_response
  end

  def next_page_url
    @parsed_response.dig("links", "next")
  end

  def next_page
    return if next_page_url.nil?

    OpenLibrary::Client.new.get_works_page(next_page_url)
  end

  def books
    return @books if @books

    @books = @parsed_response["entries"].map do |entry|
      OpenLibrary::Book.new(entry)
    end
  end

  def import!
    books.each do |book|
      if book.discworld?
        book.save!
      else
        puts "Could not import:"
        puts book.title
        puts book.subjects.inspect
      end
    end
  end
end
