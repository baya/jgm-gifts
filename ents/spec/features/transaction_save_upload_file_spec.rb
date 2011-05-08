# -*- coding: utf-8 -*-
require 'spec_helper'

describe "保存文件加入事务控制" do
  include ApplicationHelper::UploadFile

  before(:each) do
    Attachment.destroy_all
    DiskFile.destroy_all
    @store_path = DiskFile.store_path
    start_count
  end

  it "attchment保存失败，应该事务回滚" do
    file = UploadFile.new("a" * 8192, "测试报告.txt", "text/plain")
    DiskFile.stub(:create!).and_throw("attachment保存失败!")
    save_upload_file(file)
    num_should_not_change
  end

  it "diskfile保存失败，应该事务回滚" do
    file = UploadFile.new("a" * 8192, "测试报告.txt", "text/plain")
    DiskFile.stub(:create!).and_throw("diskfile保存失败!")
    save_upload_file(file)
    num_should_not_change
  end

  it "file写入磁盘失败，应该事务回滚" do
    file = UploadFile.new("a" * 8192, "测试报告.txt", "text/plain")
    File.stub(:open).with(kind_of(String), 'wb').and_throw("file写入磁盘失败!")
    save_upload_file(file)
    num_should_not_change
  end

  def start_count
    @start_count ||= { :diskfile_num_before => DiskFile.count, :attachment_num_before => Attachment.count, :files_num_before => Dir.entries(@store_path)}
  end

  def num_should_not_change
    start_count[:attachment_num_before].should == Attachment.count
    start_count[:diskfile_num_before].should == DiskFile.count
    start_count[:files_num_before].should == Dir.entries(@store_path)
  end



end
