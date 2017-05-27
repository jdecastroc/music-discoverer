require 'nokogiri'
require 'open-uri'
require 'json'

# TODO ADD STATE TO THE REQUEST (SUCCES, FAILED AND CODES)
# ADD LOGGER FOR ROR
# CHECK THE FLASH NOTICES

GENRES_URL = "https://www.reddit.com/r/Music/wiki/musicsubreddits"
#LISTA DE GENEROS A EXCEPTUAR

class Surfer 

    attr_accessor :output
    def initialize(url, deep)
	   	@playlist = Playlist.new(url)
	   	@count = 0
	   	getGenres()
	   	if deep != 0
	   	    #surf(url,deep)
	   	else
	   	    flash[:notice] = "There has been an error while parsing the music"
	   	end
    end
	
	def getReddit(url,deep)
	    puts "Page: #{deep}, estoy en #{url}"
	    doc = Nokogiri::HTML(open(url, 'User-Agent' => 'Rails test'))
	  
        doc.css("div[data-domain='youtube.com']").css("a.title").map{ |node| 
            url = node.content
            name = node['data-href-url']
            @playlist.songs.push(Song.new(url, name))
        }
        next_page = doc.at_css("span.next-button").css('a').attr('href')
        deep = deep - 1
        
        if deep.zero?
            @output = JSON.pretty_generate(@playlist.to_hash) 
            puts @output
            return @output
        end
        
        surf(next_page,deep)
 
	end
    
end