require 'spec_helper'

describe Exifice::Wrappers do
  describe 'exiftool'
  it 'returns proper path for exiftool' do
    expect(subject.exiftool).to eq File.join Dir.pwd, 'vendor', 'Image-ExifTool-10.02'
  end
end
