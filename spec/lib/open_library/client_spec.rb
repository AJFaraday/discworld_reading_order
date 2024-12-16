require "../../spec_helper.rb"

describe OpenLibrary::Client do
  let(:client) { OpenLibrary::Client.new }

  describe "get_book" do
    let(:book_id) { "OL45804W" }
    let(:mock_response) {
      double(
        {
          parsed_response: {
            title: "Mr Fox"
          }
        }
      )
    }

    it "instantiates a book from OpenLibrary" do
      expect(HTTParty).to(
        receive(:get).with(
          "https://openlibrary.org/works/#{book_id}.json"
        ).and_return(mock_response)
      )

      client.get_book(book_id)
    end
  end

  describe "get_cover" do

  end
end
