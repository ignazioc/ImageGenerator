require 'rubygems'
require 'bundler'
require 'fileutils'
Bundler.require()

require "sinatra/reloader"
require_relative "generator.rb"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    after_reload do
    end
  end

  enable :methodoverride
  set :bind, '0.0.0.0'
  set :port, 80


  get '/generate' do
    puts params
    @line1 = params[:line1]
    puts params
    backgorund, textColor = colorMap[params[:color]]

    prefix = random_name
    g = Generator.new(prefix, backgorund, textColor)
    g.render(@line1)
    generated_name = "#{prefix}_full.png"
    FileUtils.cp(generated_name, File.join('public', generated_name))

    send_file "./public/#{generated_name}", :filename => "#{generated_name}", :type => 'Application/image'
  end

  get "/" do
    erb :index
  end

  def colorMap
    map = Hash.new()
    map["green_background"] = "rgb(135, 185, 25)", "rgb(255, 255, 255)"
    map["red_background"] = "rgb(229, 50, 56)", "rgb(255, 255, 255)"
    map["blue_background"] = "rgb(0, 98, 212)", "rgb(255, 255, 255)"
    map["yellow_background"] = "rgb(245, 175, 2)", "rgb(255, 255, 255)"
    map["green_text"] = "rgb(255, 255, 255)", "rgb(135, 185, 25)"
    map["red_text"] = "rgb(255, 255, 255)", "rgb(229, 50, 56)"
    map["blue_text"] = "rgb(255, 255, 255)", "rgb(0, 98, 212)"
    map["yellow_text"] = "rgb(255, 255, 255)", "rgb(245, 175, 2)"
    map
  end

  def random_name
    (0...8).map { (65 + rand(26)).chr }.join
  end

  def sanitize_filename(filename)
    clean_name = filename.gsub(/\s+/, '_')
    clean_name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    clean_name
  end
end

App.run!
