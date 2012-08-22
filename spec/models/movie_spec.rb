require 'spec_helper'

describe Movie do
  describe 'searching same directors' do
    it 'should call Movie with director' do
      Movie.should_receive(:same_directors).with('Star Wars')
      Movie.same_directors('Star Wars')
    end
  end
end
