require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10){ [*"A".."Z"].sample }
  end

  def score
    @score = 0
    @word = params[:word]
    @letters = params[:letters]
    # The word is valid according to the grid and is an English word
    if english_word(@word) == true && valid_word?(@word, @letters) == true
      @result = 'You won!'
    elsif valid_word?(@word, @letters) == true && english_word(@word) == false
      @result =  'This word is not an english valid word'
      # The word is valid according to the grid, but is not a valid English word
    elsif valid_word?(@word, @letters) == false
      @result =  'You build wrong !'
      # The word can’t be built out of the original grid
    end
  end

  def english_word(word)
    encoded_word = URI.encode_www_form_component(word)
    url = URI.open("https://wagon-dictionary.herokuapp.com/#{encoded_word}").read
    json_response = JSON.parse(url)
    json_response['found']
  end

  def valid_word?(word, letters)
    word.upcase.chars.all? { |letter| letters.include?(letter) && letters.count(letter) >= word.upcase.count(letter) }
  end
end
