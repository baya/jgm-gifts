# -*- coding: utf-8 -*-
require 'factory_girl'

Factory.define(:refundissue) do |issue|
  issue.reg_name     '后海给力火锅'
  issue.user_name    'fantong-jim'
  issue.phone_number '13800138000'
  issue.bank_name    '支付宝'
  issue.bank_money   1.0
  issue.description  '我要退款'
  issue.name_zh      '蒋庄庄'
end

Factory.define(:tuan_order) do |order|
  order.created_at  1.day.ago
  order.updated_at  1.day.ago
  order.origin      2.0
  order.service     "alipay"
  order.mobile      "13800138000"
end

Factory.define(:tuan_team) do |team|
  team.title        '熊猫牌暖宝宝'
  team.team_price   2.0
  team.market_price 10.0
end

Factory.define(:tuan_coupon) do |coupon|
  coupon.user_id "123"
  coupon.created_at 1.day.ago
  coupon.updated_at 1.day.ago
  coupon.expire_time Time.now + 8.days
  coupon.no rand(100000000)
end

Factory.define(:tuan_account) do |account|
  account.created_at 10.day.ago
  account.updated_at 10.day.ago
end
