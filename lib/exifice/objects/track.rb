require 'nokogiri'

module Exifice
  module Objects
    class Track
      attr_reader :points

      def initialize points
        @points = points
      end

      class << self
        def load file_or_string
          xml = File.exist?(file_or_string) ? File.read(file_or_string) : file_or_string
          doc = Nokogiri::XML xml
          send :"load_#{doc.root.name}", doc
        end

      private
        def load_gpx doc
          Track.new(doc.xpath('//xmlns:trkpt').map do |trkpt|
                      Point.new [trkpt.xpath('@lat'), trkpt.xpath('@lon')].map(&:to_s)
                    end)
        end
      end
    end
  end
end
