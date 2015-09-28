module Exifice
  EARTH_RADIUS = {
    :km => 6_371,
    :mi => 3_959
  }

  module Objects
    class Point
      attr_reader :lat, :lon

      def initialize *args
        if args.length == 1
          args = args.first
          args =  case args
                  when Array then args
                  when String then args.split(/[,; &|]+/)
                  when Point then [args.lat, args.lon]
                  end
        end
        @lat, @lon = args.is_a?(Array) && args.length == 2 ? [LatLon.new(args.first, semisphere: ['N', 'S']), LatLon.new(args.last, semisphere: ['E', 'W'])] : [nil] * 2
      end

      # String representation of multitudes.
      # @param [:pretty|:float] specifies how to format the result
      # @return [String] in the form "53.121231231,-18.43534656" or "60°26′56″N 22°16′6″E"
      def to_s format = :pretty
        to_a(format).join ','
      end

      # Array representation of multitudes.
      # @param [:latlon|:pretty|:float] specifies how to format the result
      # @return [Array] [@lat, @lon]
      def to_a format = :latlon
        case format
        when :pretty then [@lat, @lon].map &:to_s
        when :float  then [@lat, @lon].map &:to_f
        else [@lat, @lon]
        end
      end

      # Calculates the nearest [lat,lon] location, basing in the value of
      #   parameter. E. g. for [53.121231231, -18.4353465] will return [53.12, -18.44].
      #   It might be useful if we need to round multitudes to present them.
      # @param slice [Number] the “modulo” to calculate nearest “rounded” value
      # @return [Point] the rounded value
      def round slice = 0.005
        Point.new [@lat, @lon].map(&:to_f).map { |ll| (ll - ll.modulo(slice)).round(Math.log(1 / slice, 10).floor + 1) }
      end

      # Checks if the multitudes behind represent the correct place on the Earth.
      # @return [TrueClass|FalseClass] _true_ if the multitudes are OK
      def valid?
        !@lat.nil? && !@lon.nil? && @lat.to_f.abs < 90 && @lon.to_f.abs < 90
      end

      # Compares against another instance.
      # @return [Boolean] _true_ if other value represents the same
      #   multitudes values, _false_ otherwise
      def == other
        other = subtrahend other
        (@lat == other.lat) && (@lon == other.lon)
      end

      # Calculates distance between two points on the Earth.
      # @param other the place on the Earth to calculate distance to
      # @return [Float] the distance between two places on the Earth
      def distance other, units = :km
        other = subtrahend other

        dlat = (other.lat.to_f - @lat.to_f).to_radians
        dlon = (other.lon.to_f - @lon.to_f).to_radians
        lat1 = @latitude.to_f.to_radians
        lat2 = other.lat.to_f.to_radians

        a = Math::sin(dlat/2)**2 + Math::sin(dlon/2)**2 * Math::cos(lat1) * Math::cos(lat2)
        (EARTH_RADIUS[units] * 2.0 * Math::atan2(Math.sqrt(a), Math.sqrt(1-a))).abs
      end
      alias_method :-, :distance

    private

      def subtrahend other
        Point.new(other).tap do |subtrahend|
          raise ArgumentError.new("Can not instantiate Point from #{other}") if subtrahend.nil?
        end
      end
    end

    class ::Numeric
      def to_radians
        self / 180.0 * Math::PI
      end
    end

    class ::String
      def to_geo
        Point.new self
      end
    end

    class ::Array
      def to_geo
        Point.new *self
      end
    end

  end

  # Calculates distance between two points on the Earth. Convenient method.
  def self.distance start, finish
    Objects::Point.new(start) - Objects::Point.new(finish)
  end

end
