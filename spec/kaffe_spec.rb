require "spec_helper"

RSpec.describe Kaffe do
  it "has a version number" do
    expect(Kaffe::VERSION).not_to be ""
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
