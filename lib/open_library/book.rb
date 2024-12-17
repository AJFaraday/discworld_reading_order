class OpenLibrary::Book
  ATTRIBUTES = %i[title description subject_people]

  # initialised using HTTParty::Response
  def initialize(response)
    @parsed_response = response.parsed_response
  end

  def cover
    @cover ||= get_cover("L")
  end

  def thumbnail
    @thumbnail ||= get_cover("S")
  end

  ATTRIBUTES.each do |attribute|
    define_method(attribute) do
      @parsed_response[attribute.to_s]
    end
  end

  def save!
    ActiveRecord::Base.transaction do
      book = Book.create!(
        title: title,
        description: description
      )

      book.thumbnail.attach(
        io: StringIO.new(thumbnail.parsed_response),
        filename: "book_#{book.id}_thumnbail.jpg"
      )

      book.cover.attach(
        io: StringIO.new(cover.parsed_response),
        filename: "book_#{book.id}_thumnbail.jpg"
      )

      book
    end
  end

  private

  def get_cover(size)
    cover_id = @parsed_response["covers"][0]
    OpenLibrary::Client.new.get_cover(cover_id, size: size)
  end
end
