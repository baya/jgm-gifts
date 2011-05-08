Feature: 查看过期退款
         为了及时处理这些搁置的诉求
         应该让业务人员更快，更方便的看到这些被搁置的退款，并且了解搁置的原因
  Scenario: 业务人员查找所有被搁置的退款诉求
     Given 有下面的用户users:
     | name    | role  | password |
     | yewu001 | yewu  | 123456   |
     | caiwu001| caiwu | 123456   |
     And 用户"caiwu001"有下面的退款诉求issues:
     | caiwu_comment | pay_number| user_name |
     |    1          |  ft-1     |  jim      |
     |    1          |  ft-2     |  kame     |
     |    1          |  ft-3     |  jack     |
     |    0          |  ft-4     |  nancy    |
     And 用户"caiwu001"对pay_number为"ft-1"的诉求有下面的注释comments:
     | content |
     | 无法从支付宝直接退款，请提供凭据 |
     | 无法从网银退款，请提供凭据      |
     And 用户"caiwu001"对pay_number为"ft-2"的诉求有下面的注释comments:
     | content                    |
     | 无法从财付通直接退款，请提供凭据 |
     And 用户"yewu001"对pay_number为"ft-2"的诉求有下面的注释comments:
     | content                    |
     | 无法找到订单号                |
     And 用户"caiwu001"对pay_number为"ft-3"的诉求有下面的注释comments:
     | content                    |
     |  退款已经过期                |
     And 我在饭后首页
     And 我用"yewu001"的帐号登录到饭后
     When 我点击"财务有注释"
     Then 我看到所有财务注释过的诉求issues:
     | caiwu_comment | pay_number| user_name | comment_content           |
     |    1          |  ft-1     |  jim      | 无法从支付宝直接退款，请提供凭据|
     |    1          |  ft-1     |  jim      | 无法从网银退款，请提供凭据     |
     |    1          |  ft-2     |  kame     | 无法从财付通直接退款，请提供凭据|
     |    1          |  ft-2     |  kame     | 无法找到订单号               |
     |    1          |  ft-3     |  jack     | 退款已经过期                 |
     And 我看不到没有财务注释的诉求issues:
     | caiwu_comment | pay_number| user_name |
     |    0          |  ft-4     |  nancy    |
