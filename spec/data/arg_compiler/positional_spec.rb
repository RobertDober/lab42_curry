require 'lab42/curry/data'

RSpec.describe Lab42::Curry::ArgCompiler do

  describe "only with rt_arg" do
    context "no compile time args" do
      let(:arg_compiler) { described_class.new [] }
      it "compiles all from the runtime args" do
        expect( arg_compiler.compile_args([1, 2, 3])).to eq([1, 2, 3])
      end
    end

    context "in order compile time args" do
      let(:arg_compiler) { described_class.new [1, 2] }
      it "compiles all from the runtime args" do
        expect( arg_compiler.compile_args([3])).to eq([1, 2, 3])
      end
    end

    context "in order compile time args" do
      let(:arg_compiler) { described_class.new [1, 2] }
      it "compiles all from the runtime args" do
        expect( arg_compiler.compile_args([3])).to eq([1, 2, 3])
      end
    end

    context "out of order compile time args" do
      describe "with placeholders" do
        let(:arg_compiler) { described_class.new [rt_arg, rt_arg, 3] }
        it "fills in at the rt_arg position, in order" do
          expect( arg_compiler.compile_args([1, 2])).to eq([1, 2, 3])
        end
      end
      describe "with reordering placeholders" do
        let(:arg_compiler) { described_class.new [rt_arg(2), rt_arg(0), 3] }
        it "fills in at the rt_arg position, in order" do
          expect( arg_compiler.compile_args([1, 2])).to eq([2, 3, 1])
        end
      end
      describe "with reordering placeholders, N.B. the 0 was superflous" do
        let(:arg_compiler) { described_class.new [rt_arg(2), rt_arg, 3] }
        it "fills in at the rt_arg position, in order" do
          expect( arg_compiler.compile_args([1, 2])).to eq([2, 3, 1])
        end
      end
    end
  end
  
  describe "only with ct_args" do
    context "instead of 1, 2 we can also write ct_args(0 => 1, 1 => 2)" do
      let(:arg_compiler) { described_class.new  [ct_args(0 => 1, 1 => 2)]  }
      it "'s a complicated way" do
        expect( arg_compiler.compile_args([3]) ).to eq([1, 2, 3])
      end
    end
    context "however this is the simplest way to reorder lots of arguments" do
      let(:arg_compiler) { described_class.new  [ct_args(3 => 1, 2 => 2)]  }
      it "makes more sense" do
        expect( arg_compiler.compile_args([4, 3]) ).to eq([4, 3, 2, 1])
      end
    end
    context "although stupid we can use ct_args more than once" do
      let(:arg_compiler) { described_class.new  [ct_args(3 => 1, 2 => 2), 4, ct_args(1 => 3)]  }
      it "have it your way" do
        expect( arg_compiler.compile_args([]) ).to eq([4, 3, 2, 1])
      end
    end
  end

  describe "mixing all of these" do
    context "ct_args, repositioning and default placeholders, do not do this, it's **really** confusing" do
      let :arg_compiler do
        described_class.new([ 
          rt_arg, # first rt_arg goes to position 0
          2,      # position 1 will be occupied by 2
          rt_arg(4), # rt_arg at position 2 will go to position 4
          ct_args(3 => 4, 5 => 6) ])
      end
      it "will all turn out somehow" do
        expect( arg_compiler.compile_args([1, 5, 3, 7]) ).to eq([*1..7])
      end
    end
  end

  describe "at least CompiletimeArgs#compile_args will raise some useful errors" do
    let(:expected_error) { Lab42::Curry::DuplicatePositionSpecification }

    shared_examples_for "duplicate position specification" do
      it "raises an error" do
        expect{arg_compiler.compile_args(runtime_args)}.to raise_error(expected_error)
      end
    end

    context "same positional arg" do
      let(:arg_compiler) { described_class.new  [1, ct_args(0 => 2)]  }
      let(:runtime_args) { [] }
      it_behaves_like "duplicate position specification"
    end

    context "conflict with placeholder" do
      let(:arg_compiler) { described_class.new  [rt_arg, ct_args(0 => 2)]  }
      let(:runtime_args) { [] }
      it_behaves_like "duplicate position specification"
    end

    context "conflict with shifted placeholder" do
      let(:arg_compiler) { described_class.new  [rt_arg(2), ct_args(2 => 2)]  }
      let(:runtime_args) { [] }
      it_behaves_like "duplicate position specification"
    end
    
    context "same shift twice" do
      let(:arg_compiler) { described_class.new  [rt_arg(2), rt_arg(2)]  }
      let(:runtime_args) { [] }
      it_behaves_like "duplicate position specification"
    end
    
  end

end
