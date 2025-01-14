# README

Presenting reading-order data for Terry Pratchett's Discworld series.

## Installation (Mac OS)

* `git clone tbc`
* `cd discworld-reading-order`
* `asdf install`
* `rake db:setup`

## Server

* `rails s`
* Open browser to "localhost:3000"

## Run Specs

* `rspec`

## Components

* `OpenLibraray` classes for retrieving data from Open Library and saving to our models
  * `OpenLibrary::Client` simple data retriever
  * `OpenLibrary::Book` Equivalent class to Book model, responsible for saving books to database. Includes logic for identifying mainline Discworld novels.
  * `OpenLibrary::WorksPage` Returns a page of works by the author and an import method
* `Db::Build` classes to kick off data import and tidying, used in `db/seeds.rb`