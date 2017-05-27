#
# Class used to store the songs info which belongs to WebResource.songs array
# 
# author: jdecastroc
# version: 2017/05/19/A
#
class Song
   
   attr_accessor :url, :name
   def initialize(url, name) 
       @url = url
       @name = name
   end
   
end