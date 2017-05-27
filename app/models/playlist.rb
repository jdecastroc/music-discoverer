#
# Class used as the main data structue which scrap and store the WebResources
# information. 
#
# @mode = Represents whether the different modes of the playlist. Random, from
# the newest...
#
# @deep = Represents how many pages the parse is going to go trough
#
# author: jdecastroc
# version: 2017/05/19/A
#

require 'nokogiri'
require 'open-uri'

class Playlist 
   
   attr_accessor :resources_list, :songs_list
   def initialize(name, resourcesUrl, mode, deep)
      @name = name
      @mode = mode # Only random for now (1)
      @deep = deep #needed?
      @resources_list = []
      @songs_list = []
      
      resourcesUrl.each { |url| 
         resource = WebResource.new("https://www.reddit.com/r/#{url}")
         getResources(resource.name, deep, resource)
      }
      
      if (mode == 1) #Get songs list and randomize
         @resources_list.each { |resource|
         
            resource.songs.each { |song|
               @songs_list.push(song) #Pensar esto
            }
            
         }
         @songs_list.shuffle!
      end
      
      #@resources = getResources()
   end
   
   def getResources(url, deep, resource)
      puts "Im in #{url}" #debug option
      
	   doc = Nokogiri::HTML(open(url, 
	         'User-Agent' => 'web:com.ReddMusic.surfReddit:v1.4 ALPHA by /u/hoppy93'))

      doc.css("div[data-domain='youtube.com']").css("a.title").map{ |node| 
   
      name = node.content
      url = node['data-href-url'][/(?<=[?&]v=)[^&$]+/]

      resource.songs.push(Song.new(url, name))
      #puts "Estoy en #{name}" #debug purpose
      }
      next_page = doc.at_css("span.next-button").css('a').attr('href')
      deep = deep - 1
        
      if deep.zero?
         #@resources_list.push(resource.to_hash) #ESTA MAL, meter en array de array
         #return JSON.pretty_generate(resource) 
         return @resources_list.push(resource)
      end
        
      getResources(next_page, deep, resource)
 
   end
   
end