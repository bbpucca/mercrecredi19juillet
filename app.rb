require_relative "./lib/scrapper"
require 'json'

class Main
	def initialize
		Scrapper.new.spreadsheets
	end
end

Main.new