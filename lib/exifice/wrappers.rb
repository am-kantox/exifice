module Exifice
  module Wrappers
    def exiftool
      Dir["#{File.absolute_path __dir__ + '/../../vendor'}/*"].detect { |d| d =~ /vendor\/Image-ExifTool-[\d.]+\z/ }
    end
    module_function :exiftool
  end
end
