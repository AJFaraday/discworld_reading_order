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
    OpenLibrary::Book.new(book_attributes)
  end

  it "returns attributes by name" do
    expect(book.title).to eq("The Colour of Magic")
    expect(book.description).to eq("The first book")
    expect(book.subject_people).to eq(%w[ Rinsewind Twoflower ])
  end

  describe "#description" do
    context "is a string" do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => "The first book",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it "should return the provided description" do
        expect(book.description).to eq("The first book")
      end
    end

    context "is a hash" do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => { "type" => "text", "value" => "The first book" },
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it "should return the provided value attribute" do
        expect(book.description).to eq("The first book")
      end
    end

    context "is nil" do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => nil,
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it "should return nil" do
        expect(book.description).to be_nil
      end
    end
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

  describe "#discworld?" do
    subject { book.discworld? }

    context 'subjects include "Discworld (Imaginary place)"' do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => "The first book",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ],
          "subjects" => [ "Discworld (Imaginary place)" ]
        }
      end

      it { should(be_truthy) }
    end

    context 'subjects do not include "Discworld (Imaginary place)"' do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => "The first book",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ],
          "subjects" => [ "other subject" ]
        }
      end

      it { should(be_falsey) }
    end

    context 'no subjects are provided' do
      let(:book_attributes) do
        {
          "title" => "The Colour of Magic",
          "description" => "The first book",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it { should(be_falsey) }
    end

    context "no description is provided" do
      let(:book_attributes) do
        {
          "title" => "Some other thing",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "subjects" => [ "Discworld (Imaginary place)" ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it { should(be_falsey) }
    end

    context "title is in list of excluded books" do
      let(:book_attributes) do
        {
          "title" => "Where's My Cow?",
          "description" => "is a book",
          "subject_people" => %w[ Rinsewind Twoflower ],
          "subjects" => [ "Discworld (Imaginary place)" ],
          "covers" => [ 12345, 99999 ]
        }
      end

      it { should(be_falsey) }
    end
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
