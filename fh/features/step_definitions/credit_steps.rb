# -*- coding: utf-8 -*-

Then /^我填写退款金额"([^"]*)"，返还余額"([^"]*)"$/ do |money, credit|
  within "#fenpei-caiwu" do
    fill_in "refundissue[yewu_money]", :with => money
    fill_in "refundissue[yewu_credit]", :with => credit
  end
end

Then /^诉求"([^"]*)"的退款金額是"([^\"]*)"，返还余額是"([^"]*)"$/ do |pay_number, money, credit|
  issue = Refundissue.find_by_pay_number(pay_number)
  issue.yewu_money.should == money.to_f
  issue.yewu_credit.should == credit.to_f
end

Then /^我退出饭后$/ do
  When %{我点击"退出"}
end

Given /^用户"([^\"]*)"没有余額帐户$/ do |u_id|
  account = TuanAccount.find_by_user_id(u_id)
  account.should == nil
end

Then /^为用户"([^\"]*)"自动生成了余額帐户$/ do |u_id|
  account = TuanAccount.find_by_user_id(u_id)
  account.should_not == nil
end


Then /^我check诉求"([^\"]*)"$/ do |pay_number|
  within("table#issues-list") do
    find("tr", :text => pay_number).check("issue_ids[]")
  end
end

Then /^余額账户"([^"]*)"的money变为"([^"]*)"$/ do |u_id, num|
  account = TuanAccount.find_by_user_id(u_id)
  account.money.should == num.to_f
end
