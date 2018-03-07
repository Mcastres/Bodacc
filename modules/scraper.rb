module Scraper
  # rubocop:disable Metrics/AbcSize
  def self.execute
    # Accepted years
    years = (2008..Time.now.year.to_i).to_a

    # If we don't already have the past years Bodacc anouncements
    # we download all of them
    if Bilan.count.zero? || years.include?(ARGV[0].to_i)
      puts 'Downloading historical files...'.light_blue
      Archives.scrape(years)
      puts 'Inserting in database...'
      insert_all
      puts 'Historical announcements finished'.light_blue
    end
    puts 'Starting to scrap actual year announcements...'.light_blue
    Actual.scrape(years)
    puts 'Inserting in database...'
    insert_all

    # Bodacc did his Job, wish him a good day
    puts 'Bodacc did his job!'.green
    puts 'Bye!'
  end
  # rubocop:enable Metrics/AbcSize

  # Every insertion are separated in their proper function,
  # this one call them all
  def self.insert_all
    insert_bilan
    insert_pcl
    insert_rcsa
    insert_rcsb
  end

  # Insert every Bilan from "tmp/xml/BILAN" into database
  def self.insert_bilan
    Dir.glob('tmp/xml/BILAN/*.xml*') do |file|
      xml = Nokogiri::XML(open(file))
      date = xml.xpath('//dateParution').first.text.to_datetime
      xml.xpath('//avis').each do |avis|
        InsertBilan.execute(avis, file, date)
      end
      FileUtils.rm(file)
    end
  end

  # Insert every PCL from "tmp/xml/PCL" into database
  def self.insert_pcl
    Dir.glob('tmp/xml/PCL/*.xml*') do |file|
      xml = Nokogiri::XML(open(file))
      date = xml.xpath('//dateParution').first.text.to_datetime
      xml.xpath('//annonce').each do |annonce|
        InsertPcl.execute(annonce, file, date)
      end
      FileUtils.rm(file)
    end
  end

  # Insert every RCS-A from "tmp/xml/RCS-A" into database
  def self.insert_rcsa
    Dir.glob('tmp/xml/RCS-A/*.xml*') do |file|
      xml = Nokogiri::XML(open(file))
      xml.xpath('//avis').each do |annonce|
        date = xml.xpath('//dateParution').first.text.to_datetime
        categorie_i = InsertImmatriculation.categorie_immat(annonce)
        InsertImmatriculation.execute(annonce, file, date, \
                                      categorie_i)
      end
      FileUtils.rm(file)
    end
  end

  # Insert every RCS-B from "tmp/xml/RCS-B" into database
  def self.insert_rcsb
    Dir.glob('tmp/xml/RCS-B/*.xml*') do |file|
      xml = Nokogiri::XML(open(file))
      xml.xpath('//avis').each do |annonce|
        date = xml.xpath('//dateParution').first.text.to_datetime
        if annonce.search('modificationsGenerales').blank?
          InsertRadiation.execute(annonce, file, date)
        else
          InsertModification.execute(annonce, file, date)
        end
      end
      FileUtils.rm(file)
    end
  end
  # rubocop:enable Metrics/ClassLength
end
