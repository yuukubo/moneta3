# == Schema Information
#
# Table name: statements
#
#  id         :integer          not null, primary key
#  amount     :integer          not null
#  memo       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_statements_on_account_id  (account_id)
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#
class Statement < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true
end
