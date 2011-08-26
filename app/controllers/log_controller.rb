class LogController < ApplicationController
  def show
    output = ""
#    output = Dir.pwd
    File.open("log/development.log", "r") do |f|
      f.seek(-10000, IO::SEEK_END)
      while (line = f.gets)
        output = output + line + '<br />'         
      end      
    end
    # Curses! remove escape sequences like esc[5;10m
    output = output.gsub(/\e\[[0-9;]*m/, "")
    render :text => output
  end
end
