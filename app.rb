require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    erb :show
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      if !@game.guess(letter)
       flash[:message] = "You have already used that letter."
      end
    rescue
      flash[:message] = "Invalid guess"
    ensure
      erb :show
      redirect '/show'
    end
  end
  
  get '/show' do
    result = @game.check_win_or_lose
    case result
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end 
  end
  
  get '/win' do
    if :win == @game.check_win_or_lose
      erb :win
    else
      redirect '/show'
    end
  end
  
  get '/lose' do
    if :lose == @game.check_win_or_lose
      erb :lose
    else
      redirect '/show'
    end
  end
end
