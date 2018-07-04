class Generator
  attr_accessor :prefix

  def initialize(prefix)
    self.prefix = prefix
  end

  def generate(lines, color = "rgb(135, 185, 25)")

    lines.each_with_index do | line, index |
      margin = ""
      if index == 0
        puts "TOP"
        margin = "-gravity north -splice 0x10 -gravity south -splice 0x4"
      elsif index == lines.count - 1
        margin = "-gravity north -splice 0x11 -gravity south -splice 0x15"
      end

      command = <<-HEREDOC
      convert -background "#{color}" \
        -size 10000x290 \
        -gravity Center \
        -fill white \
        -font HelveticaNeueCondensedBlack.ttf \
        -pointsize 95 \
        caption:"#{line}" \
        -trim \
        -bordercolor "#{color}" \
        -border 17x5 \
        -background "#{color}" #{margin}\
        #{self.prefix}_base_#{index}.png
        HEREDOC
      system( command )
    end
    merge
    return skew
  end




  def merge
    command = "convert #{self.prefix}_base_*.png -background none -gravity Center -append #{self.prefix}_merged.png"
    system( command )
  end

  def skew()
    filename = "final_#{self.prefix}.png"
    command = "./skew.sh -a 6 -m degrees -d r2t #{self.prefix}_merged.png #{filename}"
    system ( command )
    return filename
  end

  def random_name
    (0...8).map { (65 + rand(26)).chr }.join
  end
end