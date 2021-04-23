require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = ['A', 'E', 'I', 'O', 'U']

  def new
    num = rand(1..5)
    @letters = Array.new(num) { VOWELS.sample }
    @letters += Array.new(10 - num) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # binding.pry
    @word = params[:word].upcase
    @letters = params[:letters].split
    @included = validate?(@word, @letters)
    @valid_word = check_word?(@word)
    @score = 0
  end
end

private

def session
  session[:total] = 0
end

def check_word?(word)
  response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  json['found']
end

def validate?(word, grid)
  word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
end
