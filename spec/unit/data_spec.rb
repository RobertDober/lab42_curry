RSpec.describe Lab42::Curry::Data do
  describe "some pathes that are not covered by the speculations" do
    context "allowed keyword overrides with a block" do
      let(:mthd) { method(:_mthd) }
      subject do
        described_class.new!(nil, mthd, b: 1).curried
      end

      it "can be overridden" do
        expect( subject.(b: 0){ _1 * 2 } ).to eq(2)
      end
    end

    context "forbidden keyword overrides with a block" do
      let(:mthd) { method(:_mthd) }
      subject do
        described_class.new(nil, mthd, b: 1).curried
      end

      it "can be overridden" do
        expect{ subject.(b: 0){ _1 * 2 } }
          .to raise_error(Lab42::Curry::DuplicateKeywordArgument, "keyword argument :b is already defined with value 1 cannot override with 0")
      end
    end

    context "instance method currying w/o a block" do
      let(:mthd) { Hash.instance_method(:fetch) }
      subject do
        described_class.new(self, mthd, :a).curried
      end
      it "accesses a on the passed in receiver" do
        expect( subject.({a: 42}) ).to eq(42)
      end
    end
  end

  private

  def _mthd(a: 1, b: 2, &blk)
    blk.(a - b)
  end
end
