Feature: 批量退款确认
         财务人员退款的习惯是批量的退款，然后一次性的对这些已经退款的诉求进行确认
         这样能够减轻财务人员的工作负担。
       Background:
         Given 有下面的用户users:
          | name    | role | password |
          | yewu001 | yewu | 123456   |
          | caiwu002| caiwu| 123456   |
         And 有下面的订单orders:
          | pay_id  | user_id |
          | ft-001  | 75943   |
          | ft-002  | 4729458 |
          | ft-003  | 3478    |
         And 有下面的余額账户accounts:
          | user_id | money   |
          | 75943   | 0.0     |
          | 4729458 | 0.0     |
         And 有下面的退款诉求:
          | pay_number | yewu_money | yewu_credit | state |
          | ft-001     |  20.0      |  8.0        |  2    |
          | ft-002     |  30.0      |  10.0       |  2    |
          | ft-003     |  50.0      |   0.0       |  0    |

       Scenario:财务人员使用批量确认功能
         Given 财务"caiwu002"分配了下面的退款诉求:
          | pay_number | yewu_money | yewu_credit | state |
          | ft-001     |  20.0      |  8.0        |  2    |
          | ft-002     |  30.0      |  10.0       |  2    |
         When 我用"caiwu002"的帐号登录到饭后
         Then 我看到下面的退款诉求可以进行财务确认:
          | pay_number |
          | ft-001     |
          | ft-002     |
         And 我看到下面的退款诉求不在财务确认的范围内:
          | pay_number |
          | ft-003     |
         When 我check"全选"，我看到下面的退款诉求被选中:
          | pay_number |
          | ft-001     |
          | ft-002     |
         When 我点击"确认"
         Then 我看到下面的退款诉求已经被"caiwu002"确认:
         | pay_number |
         | ft-001     |
         | ft-002     |
         And 诉求"ft-001"的返利被退回到余額账户"75943"
         And 诉求"ft-002"的返利被退回到余額账户"4729458"


