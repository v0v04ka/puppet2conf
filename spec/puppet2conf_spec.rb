require 'spec_helper'

RSpec.describe Puppet2conf do
  it 'has a version number' do
    expect(Puppet2conf::VERSION).not_to be nil
  end

  it 'The old class still exists' do
    expect(Puppet2conf::GenDoc).to be_a_kind_of Class
  end

  it 'New class compiles' do
    expect(Puppet2conf::DocPusher).to be_a_kind_of Class
  end
end
