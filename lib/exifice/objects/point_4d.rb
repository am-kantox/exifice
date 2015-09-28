module Exifice
  module Objects
    class Point4D < Point3D
      attr_reader :time

      def initialize *args
        if args.length == 1
          args = args.first
          args =  case args
                  when Array then args
                  when String then args.split(/[,; &|]+/)
                  when Point4D then [args.lat, args.lon, args.alt, args.time]
                  when Point3D then [args.lat, args.lon, args.alt, nil]
                  when Point then [args.lat, args.lon, nil, nil]
                  end
        end

        args.rotate! if args.first.is_a?(Date)

        @time = Date.parse args.pop.to_s
        super args
      end

      def to_a format = :float
        super(format) << time
      end

      def to_h
        super.merge time: time
      end

    end

    class ::String
      def to_point4d
        Point4D.new self
      end
    end

    class ::Array
      def to_point4d
        Point4D.new *self
      end
    end
  end
end
