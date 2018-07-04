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
    @line2 = params[:line2]
    @line3 = params[:line3]
    puts params
    color = colorMap[params[:color]]

    Dir.glob('*.png').each { |file| File.delete(file) }

    sentences = []
    sentences << @line1.upcase if @line1.length > 0
    sentences << @line2.upcase if @line2.length > 0
    #sentences << @line3.upcase if @line3.length > 0
    puts "*** #{sentences}"
    gg = Generator.new(random_name)
    @generated_name = gg.generate(sentences, color)
    FileUtils.cp(@generated_name, File.join('public', @generated_name))

    # erb :index
    fullText = sentences.join(" ")
    filename = sanitize_filename(fullText)
    send_file "./public/#{@generated_name}", :filename => "#{filename}.png", :type => 'Application/image'
  end

  get "/" do
    erb :index
  end

  def colorMap
    map = Hash.new("rgb(135, 185, 25)")
    map["green"] = "rgb(135, 185, 25)"
    map["red"] = "rgb(229, 50, 56)"
    map["blue"] = "rgb(0, 98, 212)"
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
