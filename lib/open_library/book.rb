class OpenLibrary::Book
  ATTRIBUTES = %i[title subject_people subjects]
  DISCWORLD_INDICATORS = [
    "Discworld (Imaginary Place)",
    "Discworld (Imaginary place)"
  ]

  EXCLUDED_BOOKS = [
    "Miss Felicity Beedles The World Of Poo",
    "The Art of the Discworld",
    "The Science of Discworld",
    "Where's My Cow?",
    "The Globe",
    "The folklore of Discworld",
    "Strata"
  ]

  # initialised using HTTParty::Response
  def initialize(parsed_response)
    @parsed_response = parsed_response
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

  # Sanitize description, which is sometimes a hash
  def description
    desc = @parsed_response["description"]
    desc.is_a?(Hash) ? desc["value"] : desc
  end

  def discworld?
    has_discworld_topic? &&
      description.is_a?(String) &&
      EXCLUDED_BOOKS.exclude?(title)
  end

  def has_discworld_topic?
    DISCWORLD_INDICATORS.any? do |indicator|
      subjects&.include?(indicator)
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
