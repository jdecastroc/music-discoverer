#
# Class used to store the obtained genres from the provided scraped page
# 
# author: jdecastroc
# version: 2017/05/19/A
#
class Genre
    
    attr_accessor :name, :subgenres
    def initialize(name)
        @name = name
        @subgenres = []
    end
end