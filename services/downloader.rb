module Downloader
  def self.execute(url, file, destination_path)
    puts "Downloading #{file.gsub(/[^0-9]/, '')} file(s)"
    agent = Mechanize.new
    agent.pluggable_parser.default = Mechanize::Download
    agent.get(url).save(destination_path)
  end
end
