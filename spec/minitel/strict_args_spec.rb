require 'spec_helper'

describe Minitel::StrictArgs, '.enforce' do
  describe 'arguments' do
    before do
      @hash = {one: 1, two: 2, uuid: SecureRandom.uuid}
      @required = [:one, :uuid]
      @optional = [:two]
    end

    it 'works when all listed args are present' do
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid)  }.to_not raise_error
    end

    it 'works when optional args are omitted' do
      @hash.delete(:two)
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid)  }.to_not raise_error
    end

    it "fails when a key is missing from the arg hash" do
      @hash.delete(:one)
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid) }.to raise_error(ArgumentError)
    end

    it "fails when a key is nil" do
      @hash[:one] = nil
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid) }.to raise_error(ArgumentError)
    end

    it 'fails if the uuid column uuid is not a uuid' do
      @hash[:uuid] = "not a uuid"
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid) }.to raise_error(ArgumentError)
    end

    it 'fails if there is an extra key' do
      @hash.merge!( {foo: 3} )
      expect { Minitel::StrictArgs.enforce(@hash, @required, @optional, :uuid) }.to raise_error(ArgumentError)
    end
  end
end

