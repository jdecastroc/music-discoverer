#
# Main controller class for the project
# 
# author: jdecastroc
# version: 2017/05/27/A
# see <a href = "https://github.com/jdecastroc/music-discoverer" /> Github
#      repository </a>
# TODO:
# => ADD STATE TO THE REQUEST (SUCCES, FAIL AND CODES)
# => ADD LOGGER FOR ROR
# => CHECK THE FLASH NOTICES
# => ADD TRY/CATCH BLOCKS IN THE PARSING WITH NOKOGIRI
#

require 'nokogiri'
require 'open-uri'

# Main controller class which get the genres from the GENRES_URL page
# web resource and create a playlist given x number of web resources looking
# for youtube links. (Check class diagram for more info)
class PlaylistController < ApplicationController
    
    GENRES_URL = "https://www.reddit.com/r/Music/wiki/musicsubreddits"
    GENRES_EXCEPTIONS = []
    
    # Get the genres links from GENRES_URL and render them into the new.html.erb
    # page as a form
    #
    def new
        
        @genres = []
        get_genres()

    end
    
    # Get the parameters from the playlist form and call the scrapper to build
    # the playlist and load it
    #
    def create
        
        @playlist = Playlist.new("",params[:items],1,2) #name, resources, mode (only random for now), deep
       
    end

    private
    
    # Get the genres from GENRES_URL in order to build the form
    #
    def get_genres

	    doc = Nokogiri::HTML(open(GENRES_URL, 
	   'User-Agent' => 'web:com.ReddMusic.surfReddit:v1.4 ALPHA by /u/hoppy93'))
	    
	    doc.css("div.md").css('h2, a').each { |node|
	    
	        current_genre ||= "" # Current object where storing data
	        parsing_genre ||= "" # New parsed tag
	        genres_counter = -1 # Used for store subgenres in the array
	        
	        if node.name == 'h2'
	            parsing_genre = node.attr('id')
	            
	            if parsing_genre != current_genre
	                current_genre = parsing_genre
	                #puts node.attr('id') # debug purpose
	                @genres.push(Genre.new(node.attr('id')))
	                genres_counter += 1
	            end
	            
	        end
	        
	        if node.name == 'a' && !@genres[genres_counter].nil?
	            if parsing_genre == current_genre
	                #puts "It is #{node.attr('href')}" # debug purpose
	                @genres[genres_counter]
	                .subgenres
	                .push(Subgenre.new(node.text.strip,node.attr('href')))
	            end
	            
	        end
	        
        }
        
    end
end