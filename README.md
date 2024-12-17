# README

Presenting reading-order data for Terry Pratchett's Discworld series.

## Installation (Mac OS)

* `git clone tbc`
* `cd discworld-reading-order`
* `asdf install`
* `rake db:create`

## Server

* `rails s`
* Open browser to "localhost:3000"

## Run Specs

* `rspec`

## Components

* `OpenLibraray` classes for retrieving data from Open Library and saving to our models
  * `OpenLibrary::Client` simple data retriever
  * `OpenLibrary::Book` Equivalent class to Book model, responsible for saving books to database