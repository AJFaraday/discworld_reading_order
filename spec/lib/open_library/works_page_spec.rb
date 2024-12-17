require "spec_helper"

describe OpenLibrary::WorksPage do
  let(:response) do
    {
      "links" => {
        "next" => "/authors/OL25712A/works.json?offset=50"
      },
      "entries" => [
        {
          "subjects" => [ "Discworld (Imaginary place)" ],
          "title" => "Guards! Guards!",
          "description" => "The first Watch book",
          "covers" => 12345
        },
        {
          "subjects" => [ "Non-discworld" ],
          "title" => "Some Other Book",
          "description" => "",
          "covers" => 12345
        }
      ]
    }
  end
  let(:works_page) { OpenLibrary::WorksPage.new(response) }

  it "knows the url of the next page" do
    expect(works_page.next_page_url).to eq("/authors/OL25712A/works.json?offset=50")
  end

  it "retrieves the next page of works" do
    expect(HTTParty).to(
      receive(:get)
        .with("https://openlibrary.org/authors/OL25712A/works.json?offset=50")
        .and_return(
          double(parsed_response: response)
        )
    )

    expect(works_page.next_page).to be_a(OpenLibrary::WorksPage)
  end

  describe "#books" do
    it "returns an array of OpenLibraray::Book" do
      expect(works_page.books).to be_a(Array)
      expect(works_page.books.length).to eq(1)
      expect(works_page.books[0]).to be_a(OpenLibrary::Book)
      expect(works_page.books[0].title).to eq("Guards! Guards!")
    end

    it "rejects non-discworld books" do
      works_page.books.each do |book|
        expect(book).to be_discworld
      end
    end
  end
end
