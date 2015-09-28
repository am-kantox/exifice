module Exifice
  module Objects
    class LatLon
      attr_reader :semisphere

      def initialize ll, semisphere: nil
        case ll
        when LatLon then @semisphere, @deg, @min, @sec = ll.semisphere, ll.deg, ll.min, ll.sec
        when Array
          @semisphere, @deg, @min, @sec = [extract_semisphere(ll.first), *ll[-3..-1].map(&:to_i).map(&:abs)]
        when Numeric then from_numeric ll
        when String
          case ll
          when /(\d+°)(\d*[′'’])?(\d*[″"”])?([NSnsEWew])?/
            @semisphere, @deg, @min, @sec = extract_semisphere($4), *[$1, $2, $3].map { |e| e.nil? ? 0 : e[0...-1].to_i }
          when ->(ll) { ll.to_f.to_s == ll } then from_numeric ll.to_f
          end
        end.tap do
          @semisphere = (@semisphere & semisphere).first if @semisphere.is_a?(Array) && semisphere
        end.to_s
      end

      def ne?
        case @semisphere
        when Array then nil
        when ->(ss) { ['N', 'E'].include? ss} then true
        when ->(ss) { ['S', 'W'].include? ss} then false
        else raise "Internal error: Unknown semisphere [«#{@semisphere}» :: #{@semisphere.class}]."
        end
      end

      def to_s format = :pretty
        case format
        when :pretty then "#{deg}°#{min}′#{sec}″#{@semisphere.length > 1 ? nil : @semisphere}"
        when :float  then to_f
        end
      end

      def to_f
        (deg + min / 60.0 + sec / 3600.0) * (ne? ? +1.0 : -1.0)
      end

      %i(deg min sec).each do |m|
        define_method m do
          instance_variable_get("@#{m}") || 0.0
        end
      end

    private

      def subtrahend other
        Point.new(other).tap do |subtrahend|
          raise ArgumentError.new("Can not instantiate Point from #{other}") if subtrahend.nil?
        end
      end

      def extract_semisphere s
        case s.to_s
        when /\A[NnSsEeWw]/ then s.to_s[0].upcase
        when /\A-/ then ['S', 'W']
        else ['N', 'E']
        end
      end
      def from_numeric ll
        @semisphere = extract_semisphere ll
        @deg = ll.floor
        @min = ((ll - @deg).abs * 60).floor
        @sec = (((ll - @deg).abs * 60 - @min) * 60).round
      end
    end

    class ::Float
      def to_ll
        LatLon.new self
      end
    end

    class ::String
      def to_ll
        LatLon.new self
      end
    end

    class ::Array
      def to_ll
        LatLon.new self
      end
    end

  end
end
