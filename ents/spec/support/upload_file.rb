# -*- coding: utf-8 -*-
class UploadFile

  attr_reader :original_filename
  attr_reader :content_type

  def initialize(content, original_filename="测试报告", content_type = "text/plain")
    @content = content
    @original_filename = original_filename
    @content_type = content_type
  end

  def read(bfs)
    @lp ||= 0
    return if @content[@lp*bfs].nil?
    content = @content[@lp*bfs, bfs]
    @lp += 1
    content
  end

  def rewind
    @lp = 0
  end

end
