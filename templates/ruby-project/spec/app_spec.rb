require_relative "../lib/app"

RSpec.describe App do
  it "adds numbers" do
    expect(App.add(1, 2)).to eq(3)
  end
end


