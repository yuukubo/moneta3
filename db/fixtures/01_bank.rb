banks = [
  {
    name: "もねた",
    branches: [
      "ふたご",
      "れちくる",
      "てんびん",
    ]
  },
  {
    name: "かりす",
    branches: [
      "おひつじ",
      "おうし",
      "かに",
    ]
  },
  {
    name: "きるけ",
    branches: [
      "しし",
      "おとめ",
      "さそり",
    ]
  },
  {
    name: "てみす",
    branches: [
      "みずがめ",
      "うお",
      "みなみのさんかく",
    ]
  },
  {
    name: "ぽぽす",
    branches: [
      "いて",
      "やぎ",
      "らしんばん",
    ]
  },
  {
    name: "もねたカード",
    branches: [
      "もねたカード",
    ]
  }
]

$id = 1
banks.each_with_index do |bank, id|
  Bank.seed do |s|
    s.id = id + 1
    s.number = DigitValue.sample.to_i
    s.name = bank[:name] + (bank[:name] =~ /カード/ ? "" : "銀行")
    s.kana_name = bank[:name]
    s.myself = id == 0
  end

  bank[:branches].each do |name|
    Branch.seed do |s|
      s.id = $id
      s.number = DigitValue.sample(1, 3).to_i
      s.name = name + (name =~ /カード/ ? "" : "座支店")
      s.kana_name = name
      s.bank_id = id + 1
    end
    $id += 1
  end
end
