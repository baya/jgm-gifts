# -*- coding: utf-8 -*-
require 'spec_helper'



describe DiskFile do
  include ApplicationHelper::UploadFile

  before(:all) do
    # 增加id计数，为创建递归目录做准备
    # 9000.times { DiskFile.create!()}
  end

  before(:each) do
    DiskFile.destroy_all
    Attachment.destroy_all
    @store_path = DiskFile.store_path
  end

  it "upload_file可以按字节数读取" do
    file = UploadFile.new("a" * 8192 * 3)
    num = 0
    while (buffer = file.read(8192))
      num += 1
    end
    num.should == 3
  end

  it "生成md5 digest值" do
    upload_file = UploadFile.new("bbaa" * 8192)
    md5 = Digest::MD5.new
    while(buffer = upload_file.read(8192))
      md5.update(buffer)
    end
    upload_file.rewind
    diskfile = save_upload_file(upload_file)
    diskfile.digest.should == md5.hexdigest
  end

  it "上传文件入果没有后缀名，那么给他加上默认后缀.txt" do
    file = UploadFile.new("a" * 8192, "测试报告")
    diskfile = save_upload_file(file)
    diskfile.suffix_name.should == ".txt"
  end

  it "digest一致的DiskFile认为是相同的文件，相应的引用指数增加一" do
    file = UploadFile.new("a" * 8192)
    lambda { @diskfile = save_upload_file(file)}.should change(DiskFile, :count).by(1)
    @diskfile.refcount.should == 1
    copy_file = UploadFile.new("a" * 8192)
    lambda { @diskfile = save_upload_file(copy_file)}.should_not change(DiskFile, :count)
    @diskfile.refcount.should == 2
  end

  it "获取后缀名" do
    file = mock("upload file")
    file.should_receive(:original_filename).and_return("测试报告.txt")
    get_suffix_name(file.original_filename).should == ".txt"
    file.should_receive(:original_filename).and_return('\c:\jim\测试报告.png')
    get_suffix_name(file.original_filename).should == ".png"
  end

  it "路径算法" do
    # diskfile的id为915087004，那么diskfile的存取路径是Rails.root.to_s + /09/15/08/70/04 + 相应的后缀名
    diskfile = mock("A DiskFile")
    attachment = mock("A Attachment")
    diskfile.stub(:id).and_return(915087004)
    diskfile.stub(:attachment).and_return(attachment)
    attachment.stub(:filename).and_return("测试报告.txt")
    path = get_path(diskfile)
    path.should == "/09/15/08/70/04.txt"
    diskfile.stub(:id).and_return(1915087004)
    attachment.stub(:filename).and_return("测试报告.jpg")
    path = get_path(diskfile)
    path.should == "/19/15/08/70/04.jpg"
  end

  it "文件存储路径与通过路径算法计算得到的路径一致" do
    upload_file = UploadFile.new("a" * 8192, "测试报告.txt")
    attachment = mock("测试报告.txt")
    attachment.stub(:filename).and_return("测试报告.txt")
    diskfile = save_upload_file(upload_file)
    diskfile.stub(:attachment).and_return(attachment)
    diskfile.location.should == @store_path + get_path(diskfile)
  end

  it "正确保存文件" do
    upload_file = UploadFile.new("b" * 8192, "测试报告.txt", "text/css")
    diskfile = save_upload_file(upload_file)
    diskfile.should be_an_instance_of(DiskFile)
    diskfile.attachment.should be_an_instance_of(Attachment)
    diskfile.attachment.filename.should == "测试报告.txt"
    diskfile.attachment.mime_type.should == "text/css"
    num_str = diskfile.id.to_s.size % 2 == 0 ? diskfile.id.to_s : "0" + diskfile.id.to_s
    diskfile.location.sub(@store_path, '').gsub(/\/|\..*$/, '').should == num_str
    File.exists?(diskfile.location).should == true
  end

  def get_path(diskfile)
    num_str = diskfile.id.to_s.size % 2 == 0 ? diskfile.id.to_s : "0" + diskfile.id.to_s
    suffix_name = File.extname(diskfile.attachment.filename)
    "/" + num_str.scan(/\d\d/).join("/") + suffix_name
  end

  def get_suffix_name(filename)
    File.extname(filename)
  end

  # 此段注释作为备份，在生产环境用ApplicationHelper::UploadFile中的save_upload_file方法
  # def save_upload_file(upload_file)
  #   md5 = Digest::MD5.new
  #   while (buffer = upload_file.read(8192))
  #     md5.update(buffer)
  #   end
  #   diskfile = DiskFile.where(:digest => md5.hexdigest).first
  #   if diskfile
  #     diskfile.increment!(:refcount, 1)
  #     diskfile
  #   else
  #     diskfile = DiskFile.create(:digest => md5.hexdigest, :refcount => 1)
  #     attachment = Attachment.create(:diskfile_id => diskfile.id,:filename => upload_file.original_filename, :mime_type => upload_file.content_type)
  #     dirname = File.dirname(diskfile.location)
  #     # Dir.mkdir(dirname) unless Dir.exists?(dirname)
  #     `mkdir #{dirname} -p ` unless Dir.exists?(dirname)
  #     File.open(diskfile.location, 'wb') { |f|
  #       while (buffer = upload_file.read(8192))
  #         f.write(buffer)
  #       end
  #     }
  #     diskfile
  #   end
  # end

end
