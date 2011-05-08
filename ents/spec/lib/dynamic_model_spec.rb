#coding:utf-8
require "spec_helper"

describe "" do

  before(:all) do
    @table = FlexTable.create! @attr = { :name => "baoxiaos"}
  end

  it "动态表单名转化为Model" do
    U[@table.name].superclass.should == ActiveRecord::Base
  end

  it "动态表单名转化为节点表Model" do
    N[@table.name].superclass.should == ActiveRecord::Base
  end
end