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
    @line1 = params[:line1]
    puts params
    color = colorMap[params[:color]]

    prefix = random_name
    g = Generator.new(prefix, color)
    g.render(@line1)
    generated_name = "#{prefix}_full.png"
    FileUtils.cp(generated_name, File.join('public', generated_name))

    send_file "./public/#{generated_name}", :filename => "#{generated_name}", :type => 'Application/image'
  end

  get "/" do
    erb :index
  end

  def colorMap
    map = Hash.new("rgb(135, 185, 25)")
    map["green"] = "rgb(135, 185, 25)"
    map["red"] = "rgb(229, 50, 56)"
    map["blue"] = "rgb(0, 98, 212)"
    map["yellow"] = "rgb(245, 175, 2)"
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
