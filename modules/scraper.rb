module Scraper
  # rubocop:disable Metrics/ClassLength
  class ScraperAction
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def self.execute
      # Accepted years
      years = (2008..Time.now.year.to_i).to_a

      # Url
      url = "https://echanges.dila.gouv.fr/OPENDATA/BODACC/#{Time.now.year}/"
      url_archives = 'https://echanges.dila.gouv.fr/OPENDATA/BODACC/FluxHistorique/'

      agent = Mechanize.new # For Download

      # If we don't already have the past years Bodacc anouncements
      # we download all of them
      if Bilan.count.zero? || years.include?(ARGV[0].to_i)

        # Let's scrap this page with Nokogiri and Mechanize
        page = Nokogiri::HTML(open(url_archives))

        puts 'Downloading historical files...'.light_blue

        # Iterate on every <tr> of the table that contain every files
        page.search('//tr').each do |line|
          next if line.search('td/text()')[4].to_s.blank?
          file = line.search('td > a/text()').to_s.strip

          # If you only want to insert a special year
          if years.include? ARGV[0].to_i
            next unless file.include? ARGV[0].to_s
          end

          # Init path for archives
          path = 'tmp/archives/'

          # Gonna catch them all !
          puts "Downloading announcements of #{file.gsub(/[^0-9]/, '')} year"
          agent.pluggable_parser.default = Mechanize::Download
          agent.get(url_archives + file).save(path + file)

          puts "Decompressing entire folder of #{file.gsub(/[^0-9]/, '')} year"
          system("tar -xf #{path}#{file} -C #{path}")

          # Untar every files and move them in their correct folder
          # (ex: RCS-A_BXA20080144.taz)
          Dir.glob('tmp/archives/**/**/*.taz*') do |thefile|
            if thefile.split('/').last.include? '_'
              system("tar -xf #{thefile} -C #{get_path_archives(thefile)}")
            end
          end

          # Destroy every useless folders
          FileUtils.rmtree Dir.glob('tmp/archives/*')

          # Files are now in xml format, ready to be send in database
          # Insert announcements in database.
          puts 'Inserting in database...'.light_blue
          insert_all
        end
      end

      puts 'Historical announcements finished'.light_blue
      puts 'Starting to scrap actual year announcements...'.light_blue

      # Opening last_update file
      last_update = if File.file?('last_update.txt')
                      File.read('last_update.txt')
                    else
                      years.first
                    end

      # Nokogiri for xml scraping, Mechanize for file download
      page = Nokogiri::HTML(open(url))

      # Download every new file
      puts 'Downloading and decompresing files...'.light_blue
      page.search('//tr').each do |line|
        next if line.search('td/text()')[4].to_s.blank?
        date = line.search('td/text()')[4].to_s.strip
        file = line.search('td > a/text()').to_s.strip

        # Init path depending on the file
        path = get_path(file)
        next if path.nil?

        # Downloading them if not already
        next unless date.to_datetime > last_update
        agent.pluggable_parser.default = Mechanize::Download
        agent.get(url + file).save(path)

        # Untar every files and remove all .taz file
        system("tar -xf #{path} -C #{path.gsub(file, '')}")
        FileUtils.rm(path)

        # Files are now in xml format, ready to be send in database
        # Insert announcements in database.
        puts "Inserting #{file.split('/').last}"
        insert_all
      end

      # Saving the last time you insert bodacc announcements
      File.open('last_update.txt', 'w') { |f| f.write(Time.now) }

      # Bodacc did his Job, wish him a good day
      puts 'Bodacc did his job!'.green
      puts 'Bye!'
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Return the correct path depending on the file type
    # (ex: BILAN_BXC20080050.xml go to "tmp/xml/BILAN/BILAN_BXC20080050.xml")
    def self.get_path(file)
      if file.to_s.include? 'BILAN'
        'tmp/xml/BILAN/' + file
      elsif file.to_s.include? 'RCS-A'
        'tmp/xml/RCS-A/' + file
      elsif file.to_s.include? 'RCS-B'
        'tmp/xml/RCS-B/' + file
      elsif file.to_s.include? 'PCL'
        'tmp/xml/PCL/' + file
      end
    end

    # Return the correct path depending on the file type
    # (ex: BILAN_BXC20080050.xml go to "tmp/xml/BILAN/")
    def self.get_path_archives(file)
      if file.to_s.include? 'BILAN'
        'tmp/xml/BILAN/'
      elsif file.to_s.include? 'RCS-A'
        'tmp/xml/RCS-A/'
      elsif file.to_s.include? 'RCS-B'
        'tmp/xml/RCS-B/'
      elsif file.to_s.include? 'PCL'
        'tmp/xml/PCL/'
      end
    end

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
          Scraper::BilanAction.create(avis, file, date)
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
          Scraper::PclAction.create(annonce, file, date)
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
          categorie_i = Scraper::ImmatriculationAction.categorie_immat(annonce)
          Scraper::ImmatriculationAction.create(annonce, file, date, \
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
            Scraper::RadiationAction.create(annonce, file, date)
          else
            Scraper::ModificationAction.create(annonce, file, date)
          end
        end
        FileUtils.rm(file)
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
