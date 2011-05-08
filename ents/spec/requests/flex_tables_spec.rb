#coding:utf-8
require "spec_helper"

describe "flex_tables resources"  do

  before(:each) do
    attr = {:name=>"baoxiaos"}
    @table = FlexTable.create! attr
  end
  
  it "GET index" do
    get "/tables"
    response.should have_selector("th", :content => "表单名")
    response.should have_selector("td", :content => "baoxiaos")
  end  
end