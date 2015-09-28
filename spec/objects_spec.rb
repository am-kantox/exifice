require 'spec_helper'

describe Exifice::Objects::LatLon do
  it 'parses strings' do
    # 60°26′56″N 22°16′6″E
    expect('60°26′56″N'.to_ll.deg).to eq 60
    expect('60°26′56″N'.to_ll.min).to eq 26
    expect('60°26′56″N'.to_ll.sec).to eq 56
    expect('60°26′56″N'.to_ll.ne?).to be true

    # 60.4488884 22.2683333
    expect('60.4488884'.to_ll.deg).to eq 60
    expect(60.4488884.to_ll.min).to eq 26
    expect(60.4488884.to_ll.sec).to eq 56
    expect(-60.4488884.to_ll.ne?).to be nil
    expect('-60.4488884'.to_ll.ne?).to be nil

    # 60.4488884 22.2683333
    expect([60, 26, 56].to_ll.deg).to eq 60
    expect(['S', 60, 26, 56].to_ll.min).to eq 26
    expect(['S', 60, 26, 56].to_ll.sec).to eq 56
    expect(['S', 60, 26, 56].to_ll.ne?).to be false
    expect(['N', 60, 26, 56].to_ll.ne?).to be true
    expect([60, 26, 56].to_ll.ne?).to be nil

    expect('60.4488884'.to_ll.to_s).to eq '60°26′56″'
  end
end

describe Exifice::Objects::Point do
  it 'parses strings' do
    # 60°26′56″N 22°16′6″E
    expect('60°26′56″N 22°16′6″E'.to_latlon.lat.deg).to eq 60
    expect('60°26′56″N, 22°16′6″E'.to_latlon.lat.min).to eq 26
    expect('60°26′56″N,22°16′6″E'.to_latlon.lat.sec).to eq 56

    # 60.4488884 22.2683333
    expect('60.4488884 22.2683333'.to_latlon.lon.deg).to eq 22
    expect([60.4488884, 22.2683333].to_latlon.lon.min).to eq 16
    expect('60.4488884,22.2683333'.to_latlon.lon.sec).to eq 6

    expect('60.4488884 22.2683333'.to_latlon.to_s).to eq '60°26′56″N,22°16′6″E'
    expect('60.4488884 22.2683333'.to_latlon.round.to_a(:float)).to eq [60.44499999999999, 22.265]

    expect('60.4488884 22.2683333'.to_latlon.to_a(:float)).to eq [60.44888888888889, 22.26833333333333]
    expect('60.4488884 22.2683333'.to_latlon.to_h).to eq(lat: 60.44888888888889, lon: 22.26833333333333)
  end

  it 'does basic distance math' do
    expect(Exifice.distance('60°26′56″N,22°16′6″E', [10.0, 20.0]).round).to eq 5616
  end
end

describe Exifice::Objects::Point3D do
  it 'parses strings' do
    expect('60°26′56″N,22°16′6″E,22'.to_point3d.lat.sec).to eq 56
    expect('60°26′56″N,22°16′6″E,22'.to_point3d.alt).to eq 22.0
  end
end

describe Exifice::Objects::Point3D do
  it 'parses strings' do
    expect('60°26′56″N,22°16′6″E,22,2015-Sep-30'.to_point4d.time).to eq Date.parse('2015-Sep-30')
    expect('60°26′56″N,22°16′6″E,22'.to_point4d.alt).to eq 22.0

    expect([Date.today, '60°26′56″N', '22°16′6″E', 22].to_point4d.time).to eq Date.today
    expect(['60°26′56″N', '22°16′6″E', 22, Date.today].to_point4d.time).to eq Date.today
    expect([Date.today, '60°26′56″N', '22°16′6″E', 22].to_point4d.alt).to eq 22.0
    expect(['60°26′56″N', '22°16′6″E', 22, Date.today].to_point4d.alt).to eq 22.0
  end
end

describe Exifice::Objects::Track do
  it 'loads and understands gpx' do
    expect(Exifice::Objects::Track.load('test_data/gpx.xml').points).not_to be_empty
    expect(Exifice::Objects::Track.load('test_data/gpx.xml').points.count).to eql 407
  end
end
