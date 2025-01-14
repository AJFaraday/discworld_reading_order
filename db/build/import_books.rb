module Db
  module Build
    module ImportBooks
      def import_books
        raise "Already imported" if Book.any?
        client = OpenLibrary::Client.new

        page = client.get_works_page("OL25712A")

        until page.nil?
          page.import!
          page = page.next_page
        end
      end
    end
  end
end
