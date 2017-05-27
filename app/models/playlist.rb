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
# version: 2017/05/27/A
#

require 'nokogiri'
require 'open-uri'

class Playlist 
   
   attr_accessor :resources_list, :songs_list
   def initialize(name, resources_url, mode, deep)
      @name = name
      @mode = mode # Only random for now (1)
      @deep = deep
      @resources_list ||= []
      @songs_list ||= []
      
      resources_url.each { |url| 
         resource = WebResource.new("https://www.reddit.com/r/#{url}")
         get_resources(resource.name, deep, resource)
      }
      
      if (mode == 1) #Get songs list and randomize
         @resources_list.each { |resource|

            resource.songs.each { |song|
               @songs_list.push(song)
            }
            
         }
         @songs_list.shuffle!
      end
      
   end
   
   def get_resources(url, deep, resource)
      puts "Im in url: #{url}" #debug option
      
	   doc = Nokogiri::HTML(open(url, 
	         'User-Agent' => 'web:com.ReddMusic.surfReddit:v1.4 ALPHA by /u/hoppy93'))

      doc.css("div[data-domain='youtube.com']").css("a.title").map{ |node| 
   
      name = node.content
      url = node['data-href-url'][/(?<=[?&]v=)[^&$]+/]

      resource.songs.push(Song.new(url, name))
      #puts "Im in name: #{name}" #debug purpose
      }
      
      next_page = doc.at_css("span.next-button").css('a').attr('href')
      deep = deep - 1
        
      if deep.zero?
         return @resources_list.push(resource)
      end
        
      get_resources(next_page, deep, resource)
 
   end
   
end