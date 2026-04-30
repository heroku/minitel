# frozen_string_literal: true

require "spec_helper"

RSpec.describe Minitel::StrictArgs do
  describe ".enforce" do
    let(:input) { { one: 1, two: 2, uuid: SecureRandom.uuid } }
    let(:required_keys) { [:one, :uuid] }
    let(:optional_keys) { [:two] }

    it "works when all listed args are present" do
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.not_to raise_error
    end

    it "works when optional args are omitted" do
      input.delete(:two)
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.not_to raise_error
    end

    it "fails when a key is missing from the arg hash" do
      input.delete(:one)
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.to raise_error(ArgumentError)
    end

    it "fails when a key is nil" do
      input[:one] = nil
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.to raise_error(ArgumentError)
    end

    it "fails if the uuid column uuid is not a uuid" do
      input[:uuid] = "not a uuid"
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.to raise_error(ArgumentError)
    end

    it "fails if there is an extra key" do
      input[:foo] = 3
      expect { described_class.enforce(input, required_keys, optional_keys, :uuid) }.to raise_error(ArgumentError)
    end
  end
end
