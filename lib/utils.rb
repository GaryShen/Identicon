require 'utils/version'
require 'digest'
require 'chunky_png'

module Utils
  class Identicon
    attr_accessor :size, :hash, :background, :path

    def initialize(user_name, path)
      @hash = Digest::MD5.hexdigest(user_name.to_s)
      @color = [1, 2, 3]
      @size = 250
      @path = path
      @pixel_ratio = (@size / 6).round
      @image_size = @size - (@pixel_ratio / 1.5).round
      @square_array = {}
      @background = [255, 255, 255]
      convert_hash
    end

    def generate
      png_image = ChunkyPNG::Image.new(@image_size,
                                       @image_size,
                                       ChunkyPNG::Color.rgb(@background[0],
                                                            @background[1],
                                                            @background[2]))
      @image = ChunkyPNG::Image.new(@size,
                                    @size,
                                    ChunkyPNG::Color.rgb(@background[0],
                                                         @background[1],
                                                         @background[2]))
      @square_array.each_key do |line_key|
        line_value = @square_array[line_key]
        line_value.each_index do |col_key|
          col_value = line_value[col_key]
          next if col_value
          # draw each unit by @square_array map
          png_image.rect(
            col_key * @pixel_ratio,
            line_key * @pixel_ratio,
            (col_key + 1) * @pixel_ratio,
            (line_key + 1) * @pixel_ratio,
            ChunkyPNG::Color::TRANSPARENT,
            ChunkyPNG::Color.rgb(@color[0], @color[1], @color[2])
          )
        end
      end
      @image.compose!(png_image, @pixel_ratio / 2, @pixel_ratio / 2)
      @image.save("#{@path}/identicon.png", :fast_rgba)
    end

    private

    # square_array: map
    # @square_array => {0=>[true, false, false, false, true], 1=>[true, true, false, true, true], 2=>[false, false, false, false, false],
    # 3=>[true, false, false, false, true], 4=>[false, false, true, false, false]}
    def convert_hash
      chars = @hash[0..15].split('')
      chars.each_index do |i|
        char = chars[i]
        sq_index = (i / 3).round
        @square_array[i / 3] = [] unless @square_array.include? sq_index
        if (i % 3).zero?
          @square_array[i / 3][0] = h_to_bool(char)
          @square_array[i / 3][4] = h_to_bool(char)
        elsif i % 3 == 2
          @square_array[i / 3][1] = h_to_bool(char)
          @square_array[i / 3][3] = h_to_bool(char)
        else
          @square_array[i / 3][2] = h_to_bool(char)
        end
      end
    end

    # get bytes from hexchar and turn into boolean by even?
    def h_to_bool(value)
      value.bytes.first.even?
    end
  end
end
