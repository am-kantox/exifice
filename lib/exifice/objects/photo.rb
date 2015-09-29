module Exifice
  module Objects
    class Photo
      attr_reader :image

      def initialize path_or_image
        @image = {
          mm: case path_or_image
              when MiniMagick::Image then path_or_image
              when String then MiniMagick::Image.public_send(File.exist?(path_or_image) ? :open : :read, path_or_image)
              end,
          et: File.exist?(path_or_image) ? MiniExiftool.new(path_or_image, numerical: true) : nil
        }
      end

      def geo
        @geo ||=  %i(VersionID LatitudeRef LongitudeRef AltitudeRef TimeStamp ProcessingMethod DateStamp Altitude DateTime Latitude Longitude Position).map do |tag|
                    [tag, @image[:et]["GPS#{tag}"]]
                  end.to_h
      end

      def geo?
        !(geo[:Latitude].nil? || geo[:Longitude].nil?)
      end
    end
  end
end
