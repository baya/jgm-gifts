#coding:utf-8
require "spec_helper"

describe "动态表单相关" do

  before(:each) do
    schema = {"baoxiaos-出差报销表"=>[["username-报销人", "string"], ["depart-部门", "string"], ["body-报销原因", "text"], ["sex-性别", "string"], ["leave_at-出差时间", "datetime"], ["avatar-头像", "string"], ["love-读书", "boolean"], ["ruby-编程", "boolean"]], "baoxiao_items-报销明细"=>[["money-金额", "decimal"], ["reason-原因", "string"]]}    
    table = @table = FlexTable.create_flex_table_flex_fields(schema)
    ActiveRecord::Migration.class_eval do      
      drop_table table.name.to_u if table_exists? table.name.to_u
      drop_table table.name.to_n if table_exists? table.name.to_n    
      table.flex_tables.each do |ft|
        drop_table ft.name.to_u if table_exists? ft.name.to_u
      end
    end
  end

  it "动态创建表"  do
    table = @table
    DynamicTable.up(table)
    ActiveRecord::Migration.class_eval do
      table_exists?(table.name.to_u).should == true
      table_exists?(table.name.to_u).should == true
      table.flex_tables.each do |t|
        table_exists?(t.name.to_u).should == true
      end
    end
  end

  it "创建表的原子性" do    
    DynamicTable.up(@table)
    @table.is_valid.should be_false
    FlexTable.exists?(:id=>@table.id).should be_true
    system("rake entos:scan_dynamic_table")    
    FlexTable.exists?(:id=>@table.id).should be_false
  end
end