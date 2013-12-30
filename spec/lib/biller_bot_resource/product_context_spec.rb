require "spec_helper"

describe BillerBotResource::Product::Context do
  let(:context) { BillerBotResource::Product::Context.new(:type => "TimeProductContext", :unit_price => 1.01, :contexts => []) }

  describe :children_with_type do
    it "returns an empty array when there are no children" do
      context.children_with_type("SomeTestType").should be_empty
    end

    context "with children" do
      before :each do
        context.contexts << BillerBotResource::Product::Context.new(:type => "TimeProductContext", :unit_price => 1.01, :contexts => [])
        context.contexts.length.should == 1
      end

      it "returns an empty array when there are no matches" do
        context.children_with_type("SomeTestType").should be_empty
      end

      it "returns a single result" do
        context.children_with_type(context.contexts.first.type).length.should == 1
      end

      it "returns multiple results" do
        context.contexts << BillerBotResource::Product::Context.new(:type => context.contexts.first.type)
        context.children_with_type(context.contexts.first.type).length.should == context.contexts.length
      end

      it "is not case sensitive" do
        context.children_with_type(context.contexts.first.type.downcase).length.should == 1
      end
    end
  end
end