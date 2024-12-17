require "spec_helper"

describe OpenLibrary::Book do
  let(:book_attributes) do
    {
      "title" => "The Colour of Magic",
      "description" => "The first book",
      "subject_people" => %w[ Rinsewind Twoflower ],
      "covers" => [ 12345, 99999 ]
    }
  end
  let(:book) do
    OpenLibrary::Book.new(
      double(
        parsed_response: book_attributes
      )
    )
  end

  it "returns attributes by name" do
    expect(book.title).to eq("The Colour of Magic")
    expect(book.description).to eq("The first book")
    expect(book.subject_people).to eq(%w[ Rinsewind Twoflower ])
  end

  it "retrieves the thumbnail" do
    expect(HTTParty).to(
      receive(:get).with(
        "https://covers.openlibrary.org/b/id/12345-S.jpg"
      )
    )

    book.thumbnail
  end

  it "retrieves the cover" do
    expect(HTTParty).to(
      receive(:get).with(
        "https://covers.openlibrary.org/b/id/12345-L.jpg"
      )
    )

    book.cover
  end

  context "#save!" do
    before do
      allow(HTTParty).to(
        receive(:get).and_return(
          double(
            parsed_response: "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x00"
          )
        )
      )
    end

    it "saves it's data to a Book record" do
      model_book = book.save!

      expect(model_book).to be_a(Book)
      expect(model_book).to be_persisted
      expect(model_book.title).to eq("The Colour of Magic")
      expect(model_book.description).to eq("The first book")

      expect(model_book.thumbnail).to be_attached
      expect(model_book.cover).to be_attached
    end
  end
end
