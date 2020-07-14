# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  amount     :integer          not null
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
  belongs_to :branch
  belongs_to :user
  belongs_to :product
  has_many :statements

  delegate :name, :is_debit, :rate, :currency, to: :product

  before_validation :assign_number

  def fullname
    product.name + " " + number
  end

  def withdrow_money(n)
    self.amount -= n
    self
  end

  def assign_number
    unless number.present?
      seed = DigitValue.sample(2,2)
      seed << seed.sum
      self.number = seed.map(&:to_s).join
    end
  end
end
