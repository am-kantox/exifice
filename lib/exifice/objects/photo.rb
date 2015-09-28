require 'mini_magick'

module Exifice
  module Objects
    class Photo
      attr_reader :image

      def initialize path_or_image
        @image =  case path_or_image
                  when MiniMagick::Image then path_or_image
                  when String then MiniMagick.public_send(File.exist?(path_or_image) ? :open : :read, path_or_image)
                  end
      end

      
    end
  end
end
