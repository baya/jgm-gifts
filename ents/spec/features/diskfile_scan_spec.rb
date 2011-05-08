# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'DiskFile文件管理' do

  include ApplicationHelper::UploadFile

  before(:each) do
    Attachment.destroy_all
    DiskFile.destroy_all
    @store_path = DiskFile.store_path
    @task_dir = Rails.root.to_s + "/lib/tasks"
    file = UploadFile.new("a" * 8192, "测试报告.txt", "text/plain")
    @diskfile = save_upload_file(file)
  end

  it "扫描无人引用的文件，并删除文件以及相关记录" do
    do_rake("entos:scan_ref")
    @diskfile.refcount.should == 1
    @diskfile.attachment.should be_an_instance_of Attachment
    File.exists?(@diskfile.location).should == true
    @diskfile.update_attributes(:refcount => 0)
    do_rake("entos:scan_ref")
    DiskFile.where(:id => @diskfile.id).first.should be_nil
    Attachment.where(:id => @diskfile.attachment.id).first.should be_nil
    File.exists?(@diskfile.location).should == false
  end

  it "扫描过期的孤儿记录(有DiskFile记录但没有相应文件)" do
    File.exists?(@diskfile.location).should be_true
    File.delete(@diskfile.location)
    File.exists?(@diskfile.location).should be_false
    do_rake("entos:scan_guer")
    DiskFile.where(:id => @diskfile.id).first.should be_nil
    Attachment.where(:id => @diskfile.attachment.id).first.should be_nil
  end

  it "扫描过期的临时文件" do
    File.exists?(@diskfile.location).should be_true
    @diskfile.destroy
    do_rake("entos:scan_tmp")
    File.exists?(@diskfile.location).should be_false
  end

  def do_rake(task)
    Dir.chdir(@task_dir) do
      `rake #{task}`
    end
  end

end
