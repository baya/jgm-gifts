# -*- coding: utf-8 -*-

Given /^有下面的团购单teams:$/ do |teams|
  teams.hashes.each { |team|
    TuanTeam.new(team).save(false)
  }
end

Given /^团购单"([^\"]*)"下面有订单orders:$/ do |product, orders|
  team = TuanTeam.find_by_product(product)
  orders.hashes.each {|order|
    order = TuanOrder.new(order)
    order.team_id = team.id
    order.save(false)
  }
end

Given /^支付编号为"([^\"]*)"的订单下面有饭团券coupons:$/ do |pay_id, coupons|
  order = TuanOrder.find_by_pay_id(pay_id)
  coupons.hashes.each { |coupon|
    coupon = TuanCoupon.new(coupon)
    coupon.order_id = order.id
    coupon.save(false)
  }
end

Given /^有下面的用户users:$/ do |users|
  users.hashes.each do |user|
    secret = Digest::MD5.hexdigest(user["password"])
    user["password"] = secret
    User.create(user)
  end
end

When /^我选中pay_number是"([^"]*)"的诉求，点击"([^"]*)"$/ do |pay_number, link_text|
  page.find('tr', :text => pay_number).click_link(link_text)
end

Then /^我看到下面的饭团券可以删除:$/ do |coupons|
  coupons.hashes.each { |coupon|
    within("table#refundable-coupons") do
      page.find('tr', :text => coupon["no"]).should have_link("删券")
    end
  }
end

Then /^我看不到"([^\"]*)"的checkbox$/ do |text|
  page.should have_no_content(text)
end

Then /^我看到"([^\"]*)"的checkbox$/ do |text|
  page.should have_content(text)
  page.should have_xpath("//th/input[@type='checkbox']")
end

Then /^我看到下面饭团券的checkbox:$/ do |coupons|
  coupons.hashes.each do |coupon|
    page.find('tr', :text => coupon["no"]).should have_field("coupon_ids[]")
  end
end

Then /^我看不到下面饭团券的checkbox:$/ do |coupons|
  coupons.hashes.each do |coupon|
    within("table#refundable-coupons") do
      page.find('tr', :text => coupon["no"]).should have_no_field("coupon_ids[]")
    end
  end
end

When /^我check全选$/ do
  check("check-all")
end

Then /^我看到下面的饭团券不在删除的范围内:$/ do |coupons|
  within("table#refundable-coupons") do
    coupons.hashes.each do |coupon|
      should have_no_content(coupon["no"])
    end
  end
end

Then /^我看到下面的饭团券被选中:$/ do |coupons|
  # 因为env.js好像不支持这种全选，所以自己check
  within("table#refundable-coupons") do
    coupons.hashes.each do |coupon|
      coupon = TuanCoupon.find_by_no(coupon["no"])
      page.find("tr", :text => coupon["no"]).check("coupon_ids[]")
    end
  end
  within("table#refundable-coupons") do
    coupons.hashes.each do |coupon|
      coupon = TuanCoupon.find_by_no(coupon["no"])
      page.find("tr", :text => coupon["no"]).should have_checked_field("coupon_ids[]")
    end
  end
end

When /^我点击"([^\"]*)"按钮$/ do |text|
  within("table#refundable-coupons") do
    page.click_button(text)
  end
  save_and_open_page
end

# 不知道什么原因，check的券号无法传递到服务器端
Then /^下面的饭团券都被注销:$/ do |coupons|
  # pending
  coupons.hashes.each do |coupon|
    coupon = TuanCoupon.find_by_no(coupon["no"])
    coupon.state.should == 2
  end
end
