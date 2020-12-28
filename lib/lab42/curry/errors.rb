module Lab42
  module Curry
    DuplicateBlock                 = Class.new RuntimeError
    DuplicateKeywordArgument       = Class.new RuntimeError
    DuplicatePositionSpecification = Class.new RuntimeError
    MissingRuntimeArg              = Class.new RuntimeError
  end
end
