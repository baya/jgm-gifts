# -*- coding: utf-8 -*-
require 'spec_helper'

RSpec::Matchers.define :be_able_attachment do
  match do |table|
    table.attachment_able?
  end
end

describe FlexTable do

  describe "flex_tables's options " do
    it "when attachment => 1 attachment_able? should be true" do
      flextable = FlexTable.create!(:name => "chucais", :title => "出差表", :options => { :attachment => 1}.to_json)
      flextable.should be_able_attachment
    end

    it "when attachment => not 1 attachment_able? should be false" do
      flextable = FlexTable.create!(:name => "chucais", :title => "出差表", :options => { :attachment => 0}.to_json)
      flextable.should_not be_able_attachment
    end    
  end
  
  describe "动态表相关" do
    before(:each) do
      schema = {"baoxiaos-出差报销表"=>[["username-报销人", "string"], ["depart-部门", "string"], ["body-报销原因", "text"], ["sex-性别", "string"], ["leave_at-出差时间", "datetime"], ["avatar-头像", "string"], ["love-读书", "boolean"], ["ruby-编程", "boolean"]], "baoxiao_items-报销明细"=>[["money-金额", "decimal"], ["reason-原因", "string"]]}
      @table = FlexTable.create_flex_table_flex_fields(schema)
    end

    it "infopath导入创建主表和子表字段的记录" do
      @table.should_not be_nil
    end    
  end
end
