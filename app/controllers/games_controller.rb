require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(' ')
    if !word_valid_re_grid?(@word, @letters)
      @result = "Look closer... you can't make #{@word.upcase} out of #{params[:letters]}"
    elsif !word_valid_re_dictionary?(@word)
      @result = "Perhaps you're not from round here, but we don't consider that sequence of letters to be pleasant"
    else
      @result = "You absolute spelling LEGEEEEEND #{@word} is so valid"
    end
  end

  private

  def word_valid_re_grid?(word, letters)
    chars = word.upcase.split ''
    chars.each do |char|
      return false unless letters.include? char

      letters.delete_at(letters.index(char))
    end
    true
  end

  def word_valid_re_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_response = open(url).read
    dictionary_response_hash = JSON.parse(dictionary_response)
    dictionary_response_hash['found']
  end
end
