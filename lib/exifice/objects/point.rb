module Exifice
  module Objects
    class Point
      attr_reader :lat, :lon

      def initialize *args
        args = args.first.split(/[,; &|]+/) if args.length == 1 && args.first.is_a?(String)
        @lat, @lon = args.is_a?(Array) && args.length == 2 ? [LatLon.new(args.first, semisphere: ['N', 'S']), LatLon.new(args.last, semisphere: ['E', 'W'])] : [nil] * 2
      end

      def to_s format = :pretty
        case format
        when :pretty then "#{lat.to_s},#{lon.to_s}"
        when :float  then "#{lat.to_f},#{lon.to_f}"
        end
      end

    end

    class ::String
      def to_geo
        Point.new self
      end
    end

    class ::Array
      def to_geo
        Point.new self
      end
    end

  end
end
