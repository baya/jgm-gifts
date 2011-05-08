Feature: 批量删除饭团券
         为了让业务人员迅速处理退款诉求
         应该让业务人员能够高效，便捷地删除饭团券

   Scenario: 可删的券少于3张
       Given 有下面的团购单teams:
       | team_price | product | delivery |
       | 50         | 烤鸭     |   0      |
       And 团购单"烤鸭"下面有订单orders:
       | pay_id | realname | money | origin | quantity |
       | ft-100 | jim      |  50.0 |  100.0 |  5       |
       And 有下面的退款诉求issues:
       | pay_number | user_name | bank_money | coupon_nos    |
       | ft-100     |  jim      |  50.0      | abc1,abc2,abc3|
       And 支付编号为"ft-100"的订单下面有饭团券coupons:
       | state | consume | no    |
       |  1    |   0     | abc1  |
       |  1    |   0     | abc2  |
       |  1    |   1     | abc3  |
       |  2    |   0     | abc4  |
       |  2    |   0     | abc5  |
       |  1    |   0     | abc6  |
       And 有下面的用户users:
       | name     | role  | password |
       |  小强     |  yewu |  123456  |
       And 我在饭后首页
       And 我用"小强"的帐号登录到饭后
       When 我选中pay_number是"ft-100"的诉求，点击"操作"
       Then 我看到下面的饭团券可以删除:
       | no     |
       | abc1   |
       | abc2   |
       And 我看不到下面饭团券的checkbox:
       | no   |
       | abc1 |
       | abc2 |
       And 我看不到"全选"的checkbox
       And 我看到下面的饭团券不在删除的范围内:
       | no   |
       | abc3 |
       | abc4 |
       | abc5 |
       | abc6 |

   Scenario: 可删的券不少于3张
       Given 有下面的团购单teams:
       | team_price | product | delivery |
       | 50         | 烤鸭     |   0      |
       And 团购单"烤鸭"下面有订单orders:
       | pay_id | realname | money | origin | quantity |
       | ft-100 | jim      |  50.0 |  100.0 |  5       |
       And 有下面的退款诉求issues:
       | pay_number | user_name | bank_money |
       | ft-100     |  jim      |  50.0      |
       And 支付编号为"ft-100"的订单下面有饭团券coupons:
       | state | consume | no    |
       |  1    |   0     | abc1  |
       |  1    |   0     | abc2  |
       |  1    |   1     | abc3  |
       |  2    |   0     | abc4  |
       |  1    |   0     | abc5  |
       And 有下面的用户users:
       | name     | role  | password |
       |  小强     |  yewu |  123456  |
       And 我在饭后首页
       And 我用"小强"的帐号登录到饭后
       When 我选中pay_number是"ft-100"的诉求，点击"操作"
       Then 我看到下面的饭团券可以删除:
       | no     |
       | abc1   |
       | abc2   |
       | abc5   |
       And 我看到"全选"的checkbox
       And 我看到下面饭团券的checkbox:
       | no   |
       | abc1 |
       | abc2 |
       | abc5 |
       And 我看到下面的饭团券不在删除的范围内:
       | no   |
       | abc3 |
       | abc4 |
       When 我check全选
       Then 我看到下面的饭团券被选中:
       | no   |
       | abc1 |
       | abc2 |
       | abc5 |
       When 我点击"删券"按钮
       Then 下面的饭团券都被注销:
       | no   |
       | abc1 |
       | abc2 |
       | abc5 |


