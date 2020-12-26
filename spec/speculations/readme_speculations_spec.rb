require "speculate_about"
RSpec.describe "Speculations" do
  context "main speculation" do
    speculate_about "README.md", alternate_syntax: true
  end
end
