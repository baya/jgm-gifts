
Feature: 退余額
         有些用户需要把钱退到她的余額账户里

    Background:
         Given 有下面的用户users:
          | name    | role | password |
          | yewu001 | yewu | 123456   |
          | caiwu002| caiwu| 123456   |
         And 有下面的订单orders:
          | pay_id  | user_id |
          | ft-001  | 111     |
          | ft-002  | 222     |
          | ft-003  | 333     |
         And 有下面的余額账户accounts:
          | user_id | money   |
          | 111     | 0.0     |
          | 222     | 0.0     |
         And 有下面的退款诉求:
          | pay_number | bank_money | yewu_credit | state |
          | ft-001     |  20.0      |  8.0        |  0    |
          | ft-002     |  30.0      |  10.0       |  0    |
          | ft-003     |  50.0      |   0.0       |  0    |

    @javascript
    Scenario: 用户已经有余額帐号，直接把钱退到余額帐号里
       When 我用"yewu001"的帐号登录到饭后
       Then 我对支付编号为"ft-001"的退款诉求进行业务"操作"
       When 我点击"强制确认"
       Then 我填写退款金额"20"，返还余額"8"
       And  我点击"业务确认"
       And  诉求"ft-001"的退款金額是"20.0"，返还余額是"8.0"
       And  我退出饭后
       When 我用"caiwu002"的帐号登录到饭后
       Then 我check诉求"ft-001"
       And  我点击"确认"
       And  余額账户"111"的money变为"8.0"

    @javascript
    Scenario: 用户没有余額帐号， 先给用户创建余額帐号，然后将钱退到余額帐号里
       Given 用户"333"没有余額帐户
       When 我用"yewu001"的帐号登录到饭后
       Then 我对支付编号为"ft-003"的退款诉求进行业务"操作"
       When 我点击"强制确认"
       Then 我填写退款金额"0"，返还余額"50"
       And  我点击"业务确认"
       And  诉求"ft-003"的退款金額是"0"，返还余額是"50"
       And  我退出饭后
       When 我用"caiwu002"的帐号登录到饭后
       Then 我check诉求"ft-003"
       And  我点击"确认"
       And  为用户"333"自动生成了余額帐户
       And  余額账户"333"的money变为"50.0"
