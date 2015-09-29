require 'spec_helper'

describe Exifice::Objects::Photo do
  it 'loads tags' do
    photo = Exifice::Objects::Photo.new(File.join('test_data', 'i', '600_20150104_114911.jpg'))
    puts photo.geo
  end
end
