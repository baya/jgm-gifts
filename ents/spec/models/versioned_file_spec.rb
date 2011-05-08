# -*- coding: utf-8 -*-
require 'spec_helper'

describe VersionedFile do
  include ApplicationHelper::UploadFile

  before(:each) do
    VersionedFile.destroy_all
    @store_path = VersionedFile.store_path
  end

  it "正确保存文件" do
    html_text = "<p>a good man</p>"
    digest = Digest::MD5.hexdigest(html_text)
    version_file = save_version_file(html_text)
    version_file.digest.should == digest
    version_file.refcount.should == 1
    version_file.mime_type.should == "html"
    version_file.filesize.should == html_text.size
    File.exists?(version_file.location).should be_true
  end

  it "路径算法" do
    version_file = VersionedFile.new
    version_file.stub(:id).and_return(915087004)
    version_file.location.should == "#{@store_path}/09/15/08/70/04.html"
  end

  it "digest一致的VersionedFile认为是相同的文件，相应的引用指数增加一" do
    html_text = "<body><h1>BB.KING</h1></body>"
    lambda { @version_file = save_version_file(html_text)}.should change(VersionedFile, :count).by(1)
    @version_file.refcount.should == 1
    lambda { @version_file = save_version_file(html_text)}.should_not change(VersionedFile, :count)
    @version_file.refcount.should == 2
  end



end
