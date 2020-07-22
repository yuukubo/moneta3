# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0)
#  end_date   :date
#  number     :string           not null
#  start_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#  branch_id  :integer
#  product_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_accounts_on_account_id  (account_id)
#  index_accounts_on_branch_id   (branch_id)
#  index_accounts_on_product_id  (product_id)
#  index_accounts_on_user_id     (user_id)
#
class Account < ApplicationRecord
  belongs_to :branch, optional: true
  belongs_to :user, optional: true
  belongs_to :product
  belongs_to :account, optional: true
  has_many :statements, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :accounts, dependent: :destroy

  delegate :name, :is_debit, :rate, :currency, :minus_limit, to: :product

  scope :settlement, -> { joins(:product).where.not("products.is_fixed or products.is_credit") }
  scope :not_fixed, -> { joins(:product).where.not("products.is_fixed") }

  def fullname
    product.name + " " + number
  end

  def withdrow(money, memo = "出金")
    update(amount: amount - money)
    Statement.create(amount: money, account_id: id, memo: memo)
  end

  def deposit(money, memo = "入金")
    if product.name == "スピードくじ"
      rank = (money ^ 777777).digits.sum % 7
      money *= 2 ** (7 - rank) - 2 ** rank
      update(amount: amount + money)
      Statement.create(amount: money , account_id: id, memo: "#{rank+1}等賞")
    else
      update(amount: amount + money)
      Statement.create(amount: money, account_id: id, memo: memo)
    end
  end

  def kaiyaku
    return "クレジットカードは解約できません" if users.present?
    return "決済口座は解約できません" if accounts.present?
    return "決済口座がありません" unless account
    account.deposit(amount)
    destroy
    return nil
  end
end
