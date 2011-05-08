# -*- coding: utf-8 -*-
require 'spec_helper'

describe "文件按存储方式" do

  include ApplicationHelper::UploadFile

  before(:each) do
    Attachment.destroy_all
    DiskFile.destroy_all
  end

  it "文件按只读方式存储" do
    file = UploadFile.new("a" * 8192, "测试报告.txt", "text/plain")
    diskfile = save_upload_file(file)
    file_stat = File::Stat.new(diskfile.location)
    file_stat.writable?.should be_false
    file_stat.readable?.should be_true
  end


end
