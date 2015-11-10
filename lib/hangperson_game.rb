class HangpersonGame
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def initialize(new_word)
    @word          = new_word.downcase
    @guesses       = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError, 'No input'           if letter == nil
    raise ArgumentError, 'No input character' if letter == ''
    raise ArgumentError, 'Not a letter'       if !letter.match(/[a-zA-Z]/)

    letter.downcase!

    if @word.include?(letter)
      if @guesses.include?(letter)
        return false
      else
        @guesses += letter
        return true
      end
    else
      if @wrong_guesses.include?(letter)
        return false
      else
        @wrong_guesses += letter
        return true
      end
    end
  end

  def word_with_guesses
    displayed_string = ''
    @word.each_char do |ltr|
      if @guesses.include?(ltr)
        displayed_string += ltr
      else
        displayed_string += '-'
      end
   end
   displayed_string
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    @word.each_char do |ltr|
      return :play if !@guesses.include?(ltr)
   end
   return :win
  end

  # Get a word from remote "random word" service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
