module Exifice
  module Objects
    class Point5D < Point4D
      attr_reader :photo

      def initialize photo, *args
        @photo = Photo.new photo
        super args
      end

    end
  end
end
