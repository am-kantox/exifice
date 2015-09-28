module Exifice
  module Objects
    class Point3D < Point
      attr_reader :alt

      def initialize *args
        if args.length == 1
          args = args.first
          args =  case args
                  when Array then args
                  when String then args.split(/[,; &|]+/)
                  when Point3D then [args.lat, args.lon, args.alt]
                  when Point then [args.lat, args.lon, nil]
                  end
        end
        @alt = args.pop.to_f
        super args
      end

      def to_a format = :float
        super(format) << alt
      end

      def to_h
        super.merge alt: alt
      end

    end

    class ::String
      def to_point3d
        Point3D.new self
      end
    end

    class ::Array
      def to_point3d
        Point3D.new *self
      end
    end
  end
end
