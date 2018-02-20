# Bodacc

Bodacc is a scraper application that scrape every Bodacc announcements (2008-actual) on the DILA website in a Postgresql database [Bodacc](https://echanges.dila.gouv.fr/OPENDATA/BODACC/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Be sure to have Ruby >= 2.3.4

### Installing gems

Clone the repository and install all necessary gem by running the following command:

```sh
$ bundle install
```

### Intalling database

The repository include a dump of the empty database called "database_dump". Create your database with it by running the following command:

```sh
$ pg_dump bodacc < database_dump
```

The database is called "bodacc"

```
bodacc
  ├── bilans
  ├── immatriculations
  ├── modifications
  ├── pcls
  └── radiations
```

### Launch scraper

The scraper is a single Ruby file. Just launch it with Ruby

```sh
$ ruby scraper.rb
```

#### How to use it properly

The first time you use the scraper execute this command

```sh
$ ruby scraper.rb
```

It will download every bodacc announcements from 2008 to now. After that, if you launch the same command again, it will only download announcements that were posted after the last_update.txt datetime. Imagine you want to download just a specific year then launch the following command:

```sh
$ ruby scraper.rb 2015
```

### Structure

This is the structure of the scraper

```
├── Gemfile
├── Gemfile.lock
├── README.md
├── database_dump
├── models
│   ├── bilan.rb
│   ├── immatriculation.rb
│   ├── modification.rb
│   ├── pcl.rb
│   └── radiation.rb
├── modules
│   ├── bilan.rb
│   ├── immatriculation.rb
│   ├── modification.rb
│   ├── pcl.rb
│   └── radiation.rb
├── scraper.rb
└── tmp
    ├── archives
    └── xml
        ├── BILAN
        ├── PCL
        ├── RCS-A
        └── RCS-B
```


## How it works

Bodacc use the [Nokogiri](https://github.com/sparklemotion/nokogiri) gem and the [Mechanize](https://github.com/sparklemotion/nokogiri) gem in order to scrape and download every files. After unzipping them, the script inserts them into the bodacc database.

If you use this scraper for the first time be aware that inserting everything from 2008 to the year before actual will take a lot of time (you'll have time to watch the Star Wars saga with all the bonuses ... twice). In fact the files weigh about 300 MB and contain a total of just over 20 million announcements.

![](https://media.giphy.com/media/l0HlBO7eyXzSZkJri/giphy.gif)

At the end, the script creates a `last_update.txt` file which contain the last time bodacc announcements were inserted into database preventing to download announcements that are already added.

## Authors

* **Castres Maxime** - *Initial work* - [Mcastres](https://github.com/Mcastres)
