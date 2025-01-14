Dir.glob(Rails.root.join("db", "build", "*.rb"), &method(:require))
include Db::Build::ImportBooks

import_books

