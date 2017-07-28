require 'spec_helper'

RSpec.describe Puppet2conf do
  it 'has a version number' do
    expect(Puppet2conf::VERSION).not_to be nil
  end

  it 'New class compiles' do
    expect(Puppet2conf::DocPusher).to be_a_kind_of Class
  end
end
