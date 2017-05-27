#
# Class used to store the subgenres of the scrapped genres
# 
# author: jdecastroc
# version: 2017/05/19/A
#
class Subgenre
    
    attr_accessor :name, :url
    def initialize(name, url)
        @name = name
        @url = url
    end
end