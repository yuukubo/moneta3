class TransferForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :from_id, :integer
  attribute :bank_id, :integer
  attribute :branch_id, :integer
  attribute :account_number, :string
  attribute :amount, :integer
  attribute :memo, :string

  validates :from_id, :bank_id, :branch_id, :account_number, :amount, presence: true
  validates :amount, numericality: { only_integer: true, message: "数値を入力して下さい" }

  validate :account_present
  validate :amount_remain

  def account_present
    if !Account.find_by(number: account_number)
      errors.add(:account_number, "振込先口座が存在しません")
    end
  end

  def amount_remain
    return unless amount
    if amount > from.amount + from.minus_limit
      errors.add(:amount, "残高が不足しています")
    end
  end

  def save
    return false if invalid?
    from.withdrow(amount) && to.deposit(amount)
  end

  def bank
    @bank ||= Bank.find_by(id: bank_id)
  end

  def branch
    @branch ||= Branch.find_by(id: branch_id)
  end

  def from
    @from ||= Account.find_by(id: from_id)
  end

  def to
    @to ||= Account.find_by(number: account_number)
  end
end
