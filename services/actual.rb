class Actual
  # rubocop:disable Metrics/AbcSize
  def self.scrape(years)
    # Url
    url = "https://echanges.dila.gouv.fr/OPENDATA/BODACC/#{Time.now.year}/"

    # Opening last_update file
    last_update = find_last_update?(years)

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
      Downloader.execute(url + file, file, path)

      # Untar every files and remove all .taz file
      system("tar -xf #{path} -C #{path.gsub(file, '')}")
      FileUtils.rm(path)
    end
    # rubocop:enable Metrics/AbcSize
  end

  def self.find_last_update?(years)
    last_modification = Modification.last
    if last_modification.nil?
      years
    else
      last_modification.created_at
    end
  end

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
end
