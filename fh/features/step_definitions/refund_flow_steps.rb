# -*- coding: utf-8 -*-

Given /^有一项"([^"]*)"退款，支付编号是"([^"]*)"，订单单价是"([^"]*)"，订单数量是"([^"]*)"，退单数量是"([^"]*)"，返利是"([^"]*)"$/ do |kind, pay_number, price, quantity, refund_num, credit|
  case kind
  when "快递"
    delivery = 1
  when "券"
    delivery = 0
  end
  team = Factory(:tuan_team,
          :delivery   => delivery,
          :team_price => price
          )
  order = Factory(:tuan_order,
                  :team_id  => team.id,
                  :pay_id   => pay_number,
                  :quantity => quantity,
                  :money    => quantity.to_i * price.to_f - credit.to_f,
                  :credit   => credit)

  issue = Factory(:refundissue,
                  :bank_money => refund_num.to_i * price.to_f - credit.to_f / quantity.to_i * refund_num.to_i,
                  :pay_number => pay_number)
end

Given /^订单"([^\"]*)"有下面的券:$/ do |pay_id, coupon|
  order = TuanOrder.find_by_pay_id(pay_id)
  team  = TuanTeam.find(order.team_id)
  coupon.hashes.each { |c|
    Factory(:tuan_coupon,
            :team_id  => team.id,
            :order_id => order.id,
            :no       => c["no"],
            :state    => 1,
            :consume  => 0)
  }
end

Given /^订单"([^\"]*)"要退下面的券:$/ do |pay_number, coupon|
  issue = Refundissue.find_by_pay_number(pay_number)
  coupon_nos = coupon.hashes.map { |c| c["no"]}.join(",")
  issue.coupon_nos = coupon_nos
  issue.save
end


Then /^我对支付编号为"([^"]*)"的退款诉求进行业务"([^"]*)"$/ do |pay_number, op|
  within("#issues-list") do
    page.find('tr', :text => pay_number).click_link(op)
  end
end

Then /^我看到"([^\"]*)"张需要删除的券$/ do |coupon_num|
  page.find(:xpath, "//table[@class='issue-coupons-body']/tbody").all(:xpath, ".//tr").size.should == coupon_num.to_i
end

When /^我删除"([^\"]*)"张券$/ do |coupon_num|
  page.find(:xpath, "//table[@class='issue-coupons-body']/tbody").all(:xpath, ".//tr")[0, coupon_num.to_i].each do |coupon|
    coupon.click_link("删券")
  end
end

Then /^我只看到下面的券需要删除:$/ do |coupon|
  nos = coupon.hashes.map{ |c| c["no"]}
  page.find(:xpath, "//table[@class='issue-coupons-body']/tbody").all(:xpath, ".//tr").each { |coupon|
     nos.should include coupon.all(:xpath, ".//td")[1].text
  }
end


Then /^我删除下面的券:$/ do |coupons|
  coupons.hashes.each { |c|
    within(:xpath, "//table[@id='refundable-coupons']/tbody") do
      page.find('tr', :text => c["no"]).click_link("删券")
    end
  }
end


Then /^我看到退款金額是"([^"]*)"，返还余額是"([^"]*)"$/ do |bank_money, credit|
  within("#fenpei-caiwu") do
    find_field("refundissue_yewu_money").value.should == bank_money.to_s
    find_field("refundissue_yewu_credit").value.should == credit.to_s
  end
end

Then /^我选择财务"([^\"]*)"$/ do |name|
  within("#fenpei-caiwu") do
    select(name, :from => "refundissue_financer_id")
  end
end

Then /^退款诉求"([^\"]*)"的业务人是"([^"]*)"，财务人是"([^"]*)"，业务退款金額是"([^"]*)"， 需要返还的余額是"([^"]*)"$/ do |pay_number, yewu, caiwu, money, credit|
  issue = Refundissue.find_by_pay_number(pay_number)
  issue.issuer.name.should == yewu
  issue.financer.name.should == caiwu
  issue.yewu_money.should == money.to_f
  issue.yewu_credit.should == credit.to_f
end
