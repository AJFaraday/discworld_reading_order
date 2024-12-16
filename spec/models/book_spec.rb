require "spec_helper"

describe Book do
  let(:book) { create(:book) }

  it "builds a book using the factory" do
    expect(book).to be_a(Book)
    expect(book).to be_persisted
    expect(book.title).to eq("The Colour of Magic")
    expect(book.description).to eq("The first book")
  end
end
