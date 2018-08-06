require 'rest-client'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters.push((65 + rand(25)).chr)
    end
  end

  def score
    @input_array = params[:input_word].downcase.split("")
    @random_array = params[:random_word].downcase.split("")
    @random_array_tmp = @random_array

    return @result = "#{params[:input_word]} is not an English word." unless test_if_english_word(params[:input_word].downcase)

    @input_array.each do |letter|
      if @random_array.include?(letter)
        @random_array_tmp.delete_at(@random_array_tmp.find_index(letter))
      else
        return @result = "Sorry, #{params[:input_word]} cannot be built out of #{params[:random_word]}."
      end
      return @result = "Congrats, #{params[:input_word]} can be built out of #{params[:random_word]}." if @result.nil?
    end
  end

  private

  def test_if_english_word(word)
    response = RestClient.get("https://wagon-dictionary.herokuapp.com/#{word}")
    @json = JSON.parse(response)
    binding.pry
    return @json["found"] == true
  end
end
