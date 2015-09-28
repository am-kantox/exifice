require 'nokogiri'

module Exifice
  module Objects
    class Track
      attr_reader :points

      def initialize points
        @points = points
      end

      def << other
        @points << Point4D.new(other)
      end

      %i(time lat lon alt).each do |m|
        define_method "by_#{m}" do
          points.sort_by &m
        end
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
                      Point4D.new %w(@lat @lon xmlns:ele xmlns:time).map { |node| trkpt.xpath(node).text }
                    end)
        end

        def load_kml doc
          Track.new(doc.xpath('//xmlns:coordinates').inject([]) do |memo, coords|
                      memo | coords.text.split(/\s+/).map { |coord| Point3D.new coord }
                    end)
        end
      end
    end
  end
end
