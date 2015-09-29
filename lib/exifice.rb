require 'mini_exiftool'
require 'mini_magick'

require 'exifice/version'

require 'exifice/wrappers'
require 'exifice/objects'

MiniExiftool.command = File.join Exifice::Wrappers.exiftool, 'exiftool'

module Exifice
  # Your code goes here...
end
