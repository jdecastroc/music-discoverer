#
# Each web resource data structure belongs to a scrapped resource. It store 
# the obtained data
# 
# author: jdecastroc
# version: 2017/05/19/A
#
class WebResource
    
   attr_accessor :name, :songs
   def initialize(name)
        @name = name
        @songs = []
   end
   
   #def to_hash
   #    songs = Hash[@songs.collect { |song| [song.url, song.name] } ]
   #    songs.to_json
   #    playlist = {:name => name, :songs => songs}
   #end
    
end