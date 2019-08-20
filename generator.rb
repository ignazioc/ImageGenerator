class Token
  attr_accessor :index, :text, :type, :textColor, :backgroundColor

  def initialize(index, text, type, textColor, backgroundColor)
    self.index = index
    self.text = text
    self.type = type
    self.textColor = textColor
    self.backgroundColor = backgroundColor
  end

  def extra()
    return case type
    when :left
      "-gravity east -splice 40x0 -fill \"#{textColor}\""
    when :bold
      "-background \"#{textColor}\" -fill \"#{backgroundColor}\" -bordercolor \"#{textColor}\" -border 40x8 -kerning 1.5"
    when :right
      "-splice 40x0 -fill \"#{textColor}\""
    else
      "Error"
    end
  end
end

class Line
  attr_accessor :index, :text, :type

  def initialize(index, text, type)
    self.index = index
    self.text = text
    self.type = type
  end

  def extra()
    return case type
    when :first
      "-gravity south -splice 0x10"
    when :middle
      "-border  0x10"
    when :last
      "-splice 0x15"
    else
      "Error"
    end
  end

  def to_tokens(textColor, backgroundColor = "white")
    indices = (0...text.length).find_all { |i| text[i,1] == '*' }
    if indices.count != 2
      puts "Wrong number of stars"
      exit 1
    end
    left = text.slice(0...indices[0])
    bold = text.slice(indices[0] + 1...indices[1])
    right = text.slice(indices[1] + 1..-1)

    arr = []
    arr <<  Token.new(1, left.strip, :left, textColor, backgroundColor) if left.length > 0
    arr <<  Token.new(2, bold.strip, :bold, textColor, backgroundColor) if bold.length > 0
    arr <<  Token.new(3, right.strip, :right, textColor, backgroundColor) if right.length > 0
    arr
  end

  def hash_bold()
    (text =~ /\*.+\*/) != nil
  end
end

class Generator
  attr_accessor :prefix, :backgorundColor, :textColor

  def initialize(prefix, color = "rgb(135, 185, 25)", textColor = "rgb(255, 0, 0)")
    self.prefix = prefix
    self.backgorundColor = color
    self.textColor = textColor
  end


  def parse(t)
    lines = t.split("\n")
    return lines.map.with_index { | l, index |
      type = :middle
      type = :first if index == 0
      type = :last if index == lines.count - 1
      
      Line.new(index + 1, l, type)
    }
  end

  def render(t)
    lines = parse(t)
    lines.each { | l | 
      if l.hash_bold
        tokens = l.to_tokens(textColor, backgorundColor)
        tokens.each { | t | renderToken(t) }
        mergeTokensIntoLine(l.index)
        cleanupTokens
      else 
        renderLine(l)
      end
    }
    mergeLines
    cleanup
  end

  def renderLine(line)
    command = <<-HEREDOC
    convert \
      -background "#{backgorundColor}" \
      -font "Paralucent Condensed Heavy.otf" \
      -fill "#{textColor}" \
      -bordercolor "#{backgorundColor}" \
      -pointsize 210 \
      #{line.extra} \
      label:"#{line.text}" \
      "#{prefix}_ln_#{line.index}_.png"
      HEREDOC
    system( command )
  end

  def renderToken(token)
    command = <<-HEREDOC
    convert \
      -background "#{backgorundColor}" \
      -font "Paralucent Condensed Heavy.otf" \
      -fill white \
      -pointsize 210 \
      #{token.extra} \
      label:"#{token.text}" \
      "#{prefix}_tk_#{token.index}_.png"
      HEREDOC
    system( command )
  end


  def mergeTokensIntoLine(index)
    command = "convert #{prefix}_tk*.png -gravity Center -background \"#{backgorundColor}\" +append #{prefix}_ln_#{index}.png"
    system( command )
  end

  def mergeLines
    command = "convert #{prefix}_ln*.png -bordercolor \"#{backgorundColor}\" -append -border 160 #{prefix}_full.png"
    system( command )
  end

  def cleanup
    command = "rm -f #{prefix}_ln*.png"
    system( command )
  end

  def cleanupTokens
    command = "rm -f #{prefix}_tk*.png"
    system( command )
  end

  def random_name
    (0...8).map { (65 + rand(26)).chr }.join
  end
end


colors = {green: "rgb(135, 185, 25)", red: "rgb(229, 50, 56)", blue: "rgb(0, 98, 212)", yellow: "rgb(245, 175, 2)"}

# colors = {green: "rgb(135, 185, 25)" }

t1 = <<-HEREDOC
Say it like
*Kleinanzeigen*
HEREDOC

# t2 = <<-HEREDOC
# Lorem ipsum dolor sit amet,
# consectetur adipiscing elit,
# sed do eiusmod *tempor* incididunt
# ut labore et dolore magna aliqua
# HEREDOC


# t3 = <<-HEREDOC
# Lorem ipsum dolor sit amet,
# *consectetur* adipiscing elit,
# sed do eiusmod *tempor* incididunt
# ut labore et dolore magna *aliqua*
# HEREDOC

# texts = {t1: t1, t2: t2, t3: t3 }
# texts = {t1: t1 }

# texts.each do | textname, t |
#   colors.each do | colorname, color |
  
#     g = Generator.new("#{colorname.to_s}_#{textname.to_s}", color)
#     g.render(t)
#   end
# end



