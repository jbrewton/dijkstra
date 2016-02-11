require 'spec_helper'

describe Dijkstra do
  it 'has a version number' do
    expect(Dijkstra::VERSION).not_to be nil
  end

  it 'passes the provided example' do
    r = `bundle exec dijkstra spec/test_files/test1.txt A G`
    expect(r.strip).to eq("Shortest path is [A,B,E,G] with total cost 6")
  end

  # borrowed from http://algs4.cs.princeton.edu/44sp/
  it 'passes some other example with numeric nodes' do
    r = `bundle exec dijkstra spec/test_files/test2.txt 0 6`
    # and an additonal .0000000000000002 because floats are awesome, thanks floats.
    expect(r.strip).to eq("Shortest path is [0,2,7,3,6] with total cost 1.5100000000000002")
  end

  describe Dijkstra::Classic do
    let(:classic_version) {Dijkstra::Classic.new("spec/test_files/test1.txt", "A", "G")}
    let(:vertices) {classic_version.instance_variable_get :@vertices}
    
    it 'creates the correct number of vertices' do
      expect(vertices.count).to be 7
    end

    it 'sets the initial distances to infinity' do
      expect(vertices.map{|m| m[1].dist == Float::INFINITY}.include?(false)).to be false
    end

    it 'sets the correct neighbors' do
      expect(vertices["A"].neighbors.map{|m| m[0]}.include? "B").to be true
      expect(vertices["A"].neighbors.map{|m| m[0]}.include? "C").to be true
      expect(vertices["A"].neighbors.map{|m| m[0]}.include? "D").to be false
    end

  end
end
