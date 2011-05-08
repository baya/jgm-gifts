# -*- coding: utf-8 -*-
Given /^用户"([^\"]*)"有下面的退款诉求issues:$/ do |name, issues|
  user = User.find_by_name(name)
  issues.hashes.each { |issue|
    issue = Refundissue.new(issue)
    case user.role
      when "caiwu"; issue.financer_id = user.id
      when "yewu"; issue.issuer_id = user.id
      when "kefu"; issue.kefu_id = user.id
    end
    issue.save(false)
  }
end
Given /^用户"([^"]*)"对pay_number为"([^"]*)"的诉求有下面的注释comments:$/ do |name, pay_number, comments|
  user = User.find_by_name(name)
  issue = Refundissue.find_by_pay_number(pay_number)
  comments.hashes.each { |comment|
    issue.comments.create(comment.merge("user_id" => user.id))
  }
end

Given /^有下面的退款诉求issues:$/ do |issues|
  @issues = issues.hashes.map do |issue|
    issue = Refundissue.new(issue)
    issue.save(false)
    issue
  end
end

Given /^有下面的注释comments:$/ do |comments|
  comments = comments.hashes
  @issues.each_with_index do |issue, i|
    issue.comments.create(comments[i])
  end
end

Given /^我在饭后首页$/ do
   visit "/"
end

Given /^我用"([^\"]*)"的帐号登录到饭后$/ do |role|
  visit "/session/new"
  within("#login") do
    fill_in "user_name",     :with => role
    fill_in "user_password", :with => "123456"
  end
  click_button("登录")
end

When /^我点击"([^\"]*)"$/ do |link_text|
  click_link_or_button(link_text)
end

Then /^我看到所有财务注释过的诉求issues:$/ do |issues|
  within("table#issues-list") do
    issues.hashes.each do |issue|
      page.should have_content(issue['user_name'])
      page.should have_content(issue['pay_number'])
      page.should have_content(issue['comment_content'])
    end
  end
end

Then /^我看不到没有财务注释的诉求issues:$/ do |issues|
  within("table#issues-list") do
    issues.hashes.each do |issue|
      page.should have_no_content(issue["user_name"])
      page.should have_no_content(issue["pay_number"])
    end
  end
end
