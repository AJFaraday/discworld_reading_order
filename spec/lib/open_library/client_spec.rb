require "spec_helper"

describe OpenLibrary::Client do
  let(:client) { OpenLibrary::Client.new }

  describe "get_book" do
    let(:book_id) { "OL45804W" }
    let(:mock_response) do
      double(
        {
          parsed_response: {
            title: "Mr Fox"
          }
        }
      )
    end

    it "instantiates a book from OpenLibrary" do
      expect(HTTParty).to(
        receive(:get).with(
          "https://openlibrary.org/works/#{book_id}.json"
        ).and_return(mock_response)
      )

      expect(client.get_book(book_id)).to be_a(OpenLibrary::Book)
    end
  end

  describe "get_cover" do
    let(:cover_id)  { 12345 }

    it "gets a small cover" do
      expect(HTTParty).to(
        receive(:get).with(
          "https://covers.openlibrary.org/b/id/#{cover_id}-S.jpg"
        )
      )

      client.get_cover(cover_id, size: "S")
    end

    it "gets a large cover" do
      expect(HTTParty).to(
        receive(:get).with(
          "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg"
        )
      )

      client.get_cover(cover_id, size: "L")
    end
  end
end
