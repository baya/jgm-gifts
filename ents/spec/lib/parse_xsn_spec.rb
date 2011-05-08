#coding:utf-8
require "spec_helper"

describe Entos::ParseXsn do
  include Entos::ParseXsn

  it "验证解析xsn后返回格式" do
    file = mock("upload xsn file")
    file.should_receive(:xsn_fields).and_return({"askforleaves-请假表"=>[["sex-性别","string"]],"askforleave_items-明细表"=>[["username-申请人","string"],["depart-部门","integer"]]})
    valid_parse_xsn(file.xsn_fields).should be_true
    file.should_receive(:xsn_fields).and_return({"baoxiaos-出差报销表"=>[["username-报销人", "string"], ["depart-部门", "string"], ["body-报销原因", "text"], ["sex-性别", "string"], ["leave_at-出差时间", "datetime"], ["avatar-头像", "string"], ["love-读书", "boolean"], ["ruby-ruby", "boolean"]], "baoxiao_items-报销明细"=>[["money-金额", "decimal"], ["reason-原因", "string"]]})
    valid_parse_xsn(file.xsn_fields).should be_true
    file.should_receive(:xsn_fields).and_return({"askforleaves"=>[["sex-性别","string"]],"askforleave_items-明细表"=>[["username-申请人","string"],["depart-部门","integer"]]})
    valid_parse_xsn(file.xsn_fields).should be_false
  end

  it "验证解析xsn后返回的html格式" do
    xsn = "#{Rails.root}/tmp/cache/chuchais.xsn"
    Entos::ParseXsn::PREFIX = ''
    html(xsn).class.should == Hash
  end
end