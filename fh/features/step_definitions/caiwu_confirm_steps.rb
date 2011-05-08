# -*- coding: utf-8 -*-

Given /^有下面的订单orders:$/ do |orders|
  orders.hashes.each { |order|
    Factory(:tuan_order, order)
  }
end

Given /^有下面的余額账户accounts:$/ do |accounts|
  accounts.hashes.each { |account| Factory(:tuan_account, account)}
end

Given /^有下面的退款诉求:$/ do |issues|
  issues.hashes.each { |issue|
    issue = Factory(:refundissue, issue)
  }
end

Given /^财务"([^\"]*)"分配了下面的退款诉求:$/ do |name, issues|
  caiwu = User.find(:first, :conditions => { :name => name, :role => "caiwu"})
  issues.hashes.each do |issue|
    issue = Refundissue.find_by_pay_number(issue["pay_number"])
    issue.financer_id = caiwu.id
    issue.save!
  end
end

Then /^我看到下面的退款诉求可以进行财务确认:$/ do |issues|
   within(:xpath, "//table[@id='issues-list']/tbody") do
    issues.hashes.each { |issue|
      page.find("tr", :text => issue["pay_number"]).should have_link("财务确认")
      page.find("tr", :text => issue["pay_number"]).should have_field("issue_ids[]")
    }
   end
end

Then /^我看到下面的退款诉求不在财务确认的范围内:$/ do |issues|
   within(:xpath, "//table[@id='issues-list']/tbody") do
    issues.hashes.each { |issue| page.should_not have_content(issue["pay_number"]) }
  end
end

When /^我check"([^\"]*)"，我看到下面的退款诉求被选中:$/ do |text, issues|
  check(text)
  within(:xpath, "//table[@id='issues-list']/tbody") do
    issues.hashes.each { |issue|
      page.find("tr", :text => issue["pay_number"]).check("issue_ids[]")
    }
  end
end

Then /^我看到下面的退款诉求已经被"([^\"]*)"确认:$/ do |name, issues|
  issues.hashes.each { |issue|
    issue = Refundissue.find_by_pay_number(issue["pay_number"])
    issue.state.should == 3
    issue.pay_money.should == issue.yewu_money
    issue.financer.name.should == name
    issue.finance_confirm_time.strftime("%Y-%d-%m").should == Time.now.strftime("%Y-%d-%m")
  }
end

Then /^诉求"([^"]*)"的返利被退回到余額账户"([^"]*)"$/ do |pay_number, user_id|
  issue = Refundissue.find_by_pay_number(pay_number)
  account = TuanAccount.find_by_user_id(user_id)
  issue.yewu_credit.should == account.money
end
