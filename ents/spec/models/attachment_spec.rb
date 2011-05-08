# -*- coding: utf-8 -*-
require 'spec_helper'

describe Attachment do
  include ApplicationHelper::UploadFile
  # include MigrationHelpers

  before(:each) do
    @table = { :name => "u_table", :title => "原型表单", :is_valid => 1, :options => { "attachment" => 1}.to_json}
  end

  it "filename为空，保存失败" do
    attachment = Attachment.create()
    attachment.should be_new_record
    attachment.errors[:filename].should include("can't be blank")
  end

  it "通过上传文件的content_type获取文件的mime_type" do
    file = UploadFile.new("s" * 8192, "测试报告.jpg", "text/plain")
    diskfile = save_upload_file(file)
    diskfile.attachment.mime_type.should == "text/plain"
  end

  it "通过文件名的后缀获取文件的mime_type" do
    file = UploadFile.new("sa" * 8192, "测试报告.jpg", nil)
    diskfile = save_upload_file(file)
    diskfile.attachment.mime_type.should == "image/jpeg"
  end

  it "attachment可以属于某个作者" do
    @user = User.create!(:login => "jim_login", :name => "jim", :email => "jim@netposa.com", :password => "123456", :password_confirmation => "123456")
    @attachment = Attachment.create(:author_id => @user.id, :filename => "测试附件")
    @attachment.should respond_to(:author)
    @attachment.author.id.should == @user.id
  end

  it "attachment属于某个出差表单" do
    chucai_table = @table.merge( :name => "u_chucai", :title => "出差表单")
    chucai_fields = [{ :name => "user_name", :title => "出差人",   :value_type => "string" },
                     { :name => "fee",       :title => "报销费用",  :value_type => "float" },
                     { :name => "desc",      :title => "出差描述",  :value_type => "text"  }
                    ]
    flex_record(chucai_table, chucai_fields)
    migrate(chucai_table, chucai_fields)
    chucai_model = flex_mode(chucai_table)
    @chucai = chucai_model.create!(:user_name => "jim", :fee => 100.0, :desc => "公款吃喝")
    @chucai.should respond_to(:attachments)
    @attachment = @chucai.attachments.create(:filename => "test poly of chucai", :mime_type => "text/plain")
    @attachment.should respond_to(:container)
    @attachment.container.id.should == @chucai.id
    @chucai.attachments.where(:filename => "test poly of chucai").first.id.should == @attachment.id
  end

  it "attachment属于某个报销表单" do
    baoxiao_table = @table.merge(:name => "u_baoxiao", :title => "报销表单")
    baoxiao_fields = [{ :name => "user_name", :title => "报销人",   :value_type => "string"},
                      { :name => "project",   :title => "报销项目", :value_type => "string"},
                      { :name => "money",     :title => "报销金额", :value_type => "float"}
                     ]
    flex_record(baoxiao_table, baoxiao_fields)
    migrate(baoxiao_table, baoxiao_fields)
    baoxiao_model = flex_mode(baoxiao_table)
    baoxiao = baoxiao_model.create!(:user_name => "nancy", :project => "唱K", :money => 388)
    baoxiao.should respond_to(:attachments)
    attachment = baoxiao.attachments.create(:filename => "test poly of baoxiao", :mime_type => "text/plain")
    attachment.should respond_to(:container)
    attachment.container.id.should == baoxiao.id
    baoxiao.attachments.where(:filename => "test poly of baoxiao").first.id.should == attachment.id
  end

  it "attachment belongs to one diskfile" do
    mock_file = "This is a mock file"
    digest = Digest::MD5.digest(mock_file)
    diskfile = DiskFile.create(:digest => digest, :filesize => mock_file.size, :refcount => 1)
    diskfile.should respond_to(:attachment)
    diskfile.should respond_to(:create_attachment)
    attachment = diskfile.create_attachment(:filename => "mock_file", :description => "123")
    attachment.should respond_to(:diskfile)
    attachment.diskfile.id.should == diskfile.id
    diskfile.attachment.id.should == attachment.id
  end

  private

  def flex_mode(table)
    table_model = Object.const_set(table[:name].classify,  Class.new(ActiveRecord::Base))
    table_model.class_eval {
      set_table_name table[:name]
      has_many :attachments, :as => :container
    }
    table_model
  end



end
