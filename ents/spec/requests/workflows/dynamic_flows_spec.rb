# -*- coding: utf-8 -*-
require 'spec_helper'

describe "运行报表" do

  before(:all) do
    add_routes_runtime do
      resources :workflows do
        resources :chucais, :controller => "dynamic_flows"
        resources :baoxiaos, :controller => "dynamic_flows"
      end
    end
  end

  describe "new with attachment" do

    before(:each) do
      init_stubs("chucais", 1)
    end

    it "should show \"上传附件\"" do
      get "/workflows/1/chucais/new"
      within "form" do |form|
        form.should have_selector("label", :content => "上传附件")
        form.should have_selector("input[name='attachment']")
      end
    end

  end

  describe "new without attachment" do

    before(:each) do
      init_stubs("baoxiaos", 0)
    end

    it "should not show \"上传附件\"" do
      get "/workflows/1/baoxiaos/new"
      within "form" do |form|
        form.should_not have_selector("label", :content => "上传附件")
        form.should_not have_selector("input[name='attachment']")
      end
    end

  end

  describe "save attachment" do

    before(:each) do
      @store_path = DiskFile.store_path
      @upload_file_path = @store_path + "/upload.txt"
      unless File.exists?(@store_path + "/upload.txt")
        File.open(@upload_file_path, "w"){ |f| f.write("upload_file")}
      end
      @files_num = Dir.entries(@store_path).size
      workflow, table, form = init_stubs("baoxiaos", 1)
      controller.should_receive(:save_u_and_node).with(table,workflow.definition)
      get "/workflows/1/baoxiaos/new"
      attach_file("attachment", @upload_file_path, "text/plain")
      workflow, table, form = init_stubs("baoxiaos", 1)
      controller.should_receive(:save_u_and_node).with(table, workflow.node_definition)
      click_button "提交"
    end

    it "should be successful" do
      puts @files_num
      puts Dir.entries(@store_path).size
      @files_num.should < Dir.entries(@store_path).size
    end

  end

  describe "new with versioned_file" do

    it "should show 文本编辑器" do
    end

  end

  def init_stubs(table_name, attachment_flag=0)
    workflow = stub_model(Workflow)
    workflow.stub(:id).and_return("1")
    flow_table = stub_model(FlexTable)
    flow_table.stub(:name).and_return(table_name)
    flow_table.stub(:fields).and_return([])
    flow_table.stub(:flex_tables).and_return([])
    form = stub_model(Form)
    flow_table.stub(:options).and_return({ "access" => { "fee" => "w"}, "attachment" => attachment_flag }.to_json)
    if attachment_flag == 1
      flow_table.stub(:attachment_able?).and_return(true)
    else
      flow_table.stub(:attachment_able?).and_return(false)
    end
    workflow.stub(:flex_table).and_return(flow_table)
    form.stub(:html).and_return("<p>Test Attachment</p>")
    form.stub(:jscode).and_return("")
    workflow.stub(:node_definition).and_return({ '0' => { 'form' => "2", 'access' => "fee", 'verbs' => ["put", "get"]}})
    Workflow.stub!(:find_by_id).with("1").and_return(workflow)
    Form.stub!(:find_by_id).with("2").and_return(form)
    return workflow, flow_table, form
  end

  def given_form_table(name)
    @table = { :name => "u_table", :title => "原型表单", :is_valid => 1, :options => { "attachment" => 1}.to_json}
    form_table = @table.merge( :name => "u_#{name}", :title => "出差表单")
    form_fields = [{ :name => "user_name", :title => "出差人",   :value_type => "string" },
                     { :name => "fee",       :title => "报销费用",  :value_type => "float" },
                     { :name => "desc",      :title => "出差描述",  :value_type => "text"  }
                    ]
    flex_record(form_table, form_fields)
    migrate(form_table, form_fields)
  end

end
