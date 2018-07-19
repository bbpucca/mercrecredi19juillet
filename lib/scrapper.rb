require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "google_drive"
require 'csv'





class Scrapper

  attr_accessor :hash

  def initialize
    @hash = Hash[get_the_city_name.zip(get_all_mail)]
    File.open("./db/email.json", "w") do |f|
      f.write(hash)
    end
  end

#   def csv
# @hash = Hash[get_the_city_name.zip(get_all_mail)]
# CSV.foreach("./db/file.csv") do |row|
#   f.write(hash)
# end

  def get_the_city_name
    nom_ville = []

    page = Nokogiri::HTML(open('http://annuaire-des-mairies.com/val-d-oise.html'))
    page.xpath('//p/a').each do |ville|
      nom_ville << ville.text
      end
    nom_ville
  end

  def get_all_url
    tab_url = []

    page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
    lien = page.css('//p/a').select{ |link| link['class'] == "lientxt" }

    lien.each do |link|
      tab_url << link['href'].sub(".", "http://annuaire-des-mairies.com")
    end
    tab_url
  end

  def get_all_mail
    tab_mail = []

    get_all_url.each do |url|
      mail = Nokogiri::HTML(open(url))
      tab_mail << mail.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
    end
    tab_mail
  end
  def spreadsheets
    session = GoogleDrive::Session.from_config("../config.json")
    ws = session.spreadsheet_by_key("15VgrlJinTVDCgrXFefjrVLPadqWeRbxC2R4wKJi7lms").worksheets[0]
    counter_row = 1
    @hash.each_with_index do |(key, value),index|
    ws[counter_row, 1] = key
    ws[counter_row, 2] = value
    counter_row += 1
    end
    ws.save
  end
end





  
