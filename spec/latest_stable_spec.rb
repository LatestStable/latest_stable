require 'spec_helper'

describe LatestStable do
  it 'has a version number' do
    expect(LatestStable::VERSION).not_to be nil
  end
end
