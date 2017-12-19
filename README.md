# Boaper

Boaper is a scraper application that scrape every BODACC announcement on the DILA website [Bodacc](https://echanges.dila.gouv.fr/OPENDATA/BODACC/2017/) and save it in postgresql database

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Be sure to have Ruby >= 2.3.4 and Rails 5

### Installing

Clone the repository and start rails server

```
$> bundle install
$> rails db:setup
$> rails s
```

Home route    => GET '/'

Scraper route => GET '/scraper'

## How it works

Boaper use the Nokogiri [gem](https://github.com/sparklemotion/nokogiri) and Mechanize [gem](https://github.com/sparklemotion/nokogiri) in order to scrap and download every files. After having decompressed them, they are registered in a postgresql database.

If you use this scraper for the first time, inserting 2008-2016 announcements might take a looooooong time. There is more than 20 millions announcements to insert so...

That's it !

## Built With

* [Rails](http://rubyonrails.org/) - The Ruby web framework used

## Authors

* **Castres Maxime** - *Initial work* - [Mcastres](https://github.com/Mcastres)
