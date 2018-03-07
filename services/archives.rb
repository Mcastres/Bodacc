class Archives
  # rubocop:disable Metrics/AbcSize
  def self.scrape(years)
    url_archives = 'https://echanges.dila.gouv.fr/OPENDATA/BODACC/FluxHistorique/'
    page = Nokogiri::HTML(open(url_archives))
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
      Downloader.execute(url_archives + file, file, path + file)

      # puts "Decompressing entire folder of #{file.gsub(/[^0-9]/, '')} year"
      system("tar -xf #{path}#{file} -C #{path}")

      # Untar every files and delete he empty folder
      untar
    end
  end
  # rubocop:enable Metrics/AbcSize

  def self.untar
    Dir.glob('tmp/archives/**/**/*.taz*') do |thefile|
      if thefile.split('/').last.include? '_'
        system("tar -xf #{thefile} -C #{get_path_archives(thefile)}")
      end
    end
    # Destroy every useless folders
    FileUtils.rmtree Dir.glob('tmp/archives/*')
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
end
