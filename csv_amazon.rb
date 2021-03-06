#coding:UTF-8
require 'csv'
require "date"

CSV.open('amazon_yamato.csv', 'w', encoding:"cp932") do |csv|
  csv << [
    "お客様管理番号", # 1
    "送り状種類", # 2 必須
    "クール区分", # 3
    "伝票番号", # 4
    "出荷予定日", # 5 必須
    "お届け予定日", # 6
    "配達時間帯", # 7
    "お届け先コード", #8
    "お届け先電話番号", # 9 必須
    "お届け先電話番号枝番", # 10
    "お届け先郵便番号", # 11 必須
    "お届け先住所", # 12 必須
    "お届け先アパートマンション名", # 13
    "お届け先会社・部門１", # 14
    "お届け先会社・部門２", # 15
    "お届け先名", # 16 必須
    "お届け先名(ｶﾅ)", # 17
    "敬称", # 18
    "ご依頼主コード", # 19
    "ご依頼主電話番号", # 20
    "ご依頼主電話番号枝番", # 21
    "ご依頼主郵便番号", # 22
    "ご依頼主住所", # 23
    "ご依頼主アパートマンション", # 24
    "ご依頼主名", # 25
    "ご依頼主名(ｶﾅ)", # 26
    "品名コード１", # 27
    "品名１", # 28
    "品名コード２", # 29
    "品名２", # 30
    "荷扱い１", # 31
    "荷扱い２", # 32
    "記事", # 33
    "ｺﾚｸﾄ代金引換額（税込)", # 34
    "内消費税額等", # 35
    "止置き", # 36
    "営業所コード", # 37
    "発行枚数", # 38
    "個数口表示フラグ", # 39
    "請求先顧客コード", # 40
    "請求先分類コード", # 41
    "運賃管理番号", # 42
    "クロネコwebコレクトデータ登録", # 43
    "クロネコwebコレクト加盟店番号", # 44
    "クロネコwebコレクト申込受付番号１", # 45
    "クロネコwebコレクト申込受付番号２", # 46
    "クロネコwebコレクト申込受付番号３", # 47
    "お届け予定ｅメール利用区分", # 48
    "お届け予定ｅメールe-mailアドレス", # 49
    "入力機種", # 50
    "お届け予定ｅメールメッセージ", # 51
    "お届け完了ｅメール利用区分", # 52
    "お届け完了ｅメールe-mailアドレス", # 53
    "お届け完了ｅメールメッセージ", # 54
    "クロネコ収納代行利用区分", # 55
    "予備", # 56
    "収納代行請求金額(税込)", # 57
    "収納代行内消費税額等", # 58
    "収納代行請求先郵便番号", # 59
    "収納代行請求先住所", # 60
    "収納代行請求先住所（アパートマンション名）", # 61
    "収納代行請求先会社・部門名１", # 62
    "収納代行請求先会社・部門名２", # 63
    "収納代行請求先名(漢字)", # 64
    "収納代行請求先名(カナ)", # 65
    "収納代行問合せ先名(漢字)", # 66
    "収納代行問合せ先郵便番号", # 67
    "収納代行問合せ先住所", # 68
    "収納代行問合せ先住所（アパートマンション名）", # 69
    "収納代行問合せ先電話番号", # 70
    "収納代行管理番号", # 71
    "収納代行品名", # 72
    "収納代行備考", # 73
    "複数口くくりキー", # 74
    "検索キータイトル1", # 75
    "検索キー1", # 76
    "検索キータイトル2", # 77
    "検索キー2", # 78
    "検索キータイトル3", # 79
    "検索キー3", # 80
    "検索キータイトル4", # 81
    "検索キー4", # 82
    "検索キータイトル5", # 83
    "検索キー5", # 84
    "予備", # 85
    "予備", # 86
    "投函予定メール利用区分", # 87
    "投函予定メールe-mailアドレス", # 88
    "投函予定メールメッセージ", # 88
    "投函完了メール（お届け先宛）利用区分", # 90
    "投函完了メール（お届け先宛）e-mailアドレス", # 91
    "投函完了メール（お届け先宛）メールメッセージ", # 92
    "投函完了メール（ご依頼主宛）利用区分", # 93
    "投函完了メール（ご依頼主宛）e-mailアドレス", # 94
    "投函完了メール（ご依頼主宛）メールメッセージ" # 95
  ]
end

CSV.open('temporary.csv','w', :force_quotes => true) do |people|
  File.foreach("ama.txt") {|line| people <<  line.chomp.split(/\t/)}
end

CSV.foreach("temporary.csv", encoding: "cp932:utf-8", headers: true).with_index(1) do |csv, index|
    # 行に対する処理
    @index = index
    invoice_type = 0 # 2

    expected_delivery_date = "最短日" # 6
    buyer_phone_number = csv['buyer-phone-number'] # 9
    recipient_name = csv['recipient-name'] # 16

    ship_postal_code = csv['ship-postal-code'] #11
    ship_state = csv['ship-state']
    ship_city = csv['ship-city']
    ship_address_1 = csv['ship-address-1']
    ship_address_2 = csv['ship-address-2']
    ship_address_3 = csv['ship-address-3']
    ship_full_address = "#{ship_state}#{ship_city}#{ship_address_1}#{ship_address_2}#{ship_address_3}" # 12
    honorific_title = "様" # 18

    client_code = "0312345678" # 19
    client_phone_number = "03-1234-5678" # 20
    client_phone_branch_number = "00" # 21
    client_zip_code = "100-0001" # 22
    client_address = "東京都永田町1-1-1" # 23
    client_bilding_name ="なんとかビル" # 24
    client_name = "なんとか株式会社" # 25
    client_name_furigana = "ﾅﾝﾄｶｶﾌﾞｼｷｶﾞｲｼｬ" # 26
    product_name = "商品" # 28
    billing_code = "0312345678" # 40
    billing_class_code = "01" # 42


    CSV.open('amazon_yamato.csv', 'a', encoding: "cp932:utf-8") do |csv|
    csv << [
      "", # 1お客様管理番号
      invoice_type, # 2送り状種類 必須
      "", # 3クール区分
      "", # 4伝票番号
      Date.today.strftime("%Y/%m/%d"), # 5出荷予定日 必須
      expected_delivery_date, # 6お届け予定日
      "", # 7配達時間帯
      "", # 8お届け先コード
      buyer_phone_number, # 9お届け先電話番号 必須
      "", # お届け先電話番号枝番10
      ship_postal_code, # 11お届け先郵便番号 必須
      ship_full_address, # 12お届け先住所" 必須
      "", # 13お届け先アパートマンション名
      "", # 14お届け先会社・部門１
      "", # 15お届け先会社・部門２
      recipient_name, #お届け先名 16 必須
      "", # 17お届け先名(ｶﾅ)
      honorific_title, # 18敬称
      client_code, # 19ご依頼主コード 必須
      client_phone_number, # 20ご依頼主電話番号 必須
      client_phone_branch_number, # 21ご依頼主電話番号枝番 必須
      client_zip_code, # 22ご依頼主郵便番号 必須
      client_address, # 23ご依頼主住所 必須
      client_bilding_name, # 24ご依頼主アパートマンション 必須
      client_name, # 25ご依頼主名 必須
      client_name_furigana, # 26ご依頼主名(ｶﾅ)
      "", # 27品名コード１
      product_name, # 28品名１ 必須
      "", # 29品名コード２
      "", # 30品名２
      "", # 31荷扱い１
      "", # 32荷扱い２
      "", # 33記事
      "", # 34ｺﾚｸﾄ代金引換額（税込)
      "", # 35内消費税額等
      "", # 36止置き
      "", # 37営業所コード
      "", # 38発行枚数
      "", # 39個数口表示フラグ
      billing_code, # 40請求先顧客コード 必須
      "", # 41請求先分類コード
      billing_class_code, # 42運賃管理番号 必須
      "", # 43クロネコwebコレクトデータ登録
      "", # 44クロネコwebコレクト加盟店番号
      "", # 45クロネコwebコレクト申込受付番号１
      "", # 46クロネコwebコレクト申込受付番号２
      "", # 47クロネコwebコレクト申込受付番号３
      "", # 48お届け予定ｅメール利用区分
      "", # 49お届け予定ｅメールe-mailアドレス
      "", # 50入力機種
      "", # 51お届け予定ｅメールメッセージ
      "", # 52お届け完了ｅメール利用区分
      "", # 53お届け完了ｅメールe-mailアドレス
      "", # 54お届け完了ｅメールメッセージ
      "", # 55クロネコ収納代行利用区分
      "", # 56予備
      "", # 57収納代行請求金額(税込)
      "", # 58収納代行内消費税額等
      "", # 59収納代行請求先郵便番号
      "", # 60収納代行請求先住所
      "", # 61収納代行請求先住所（アパートマンション名）
      "", # 62収納代行請求先会社・部門名１
      "", # 63収納代行請求先会社・部門名２
      "", # 64収納代行請求先名(漢字)
      "", # 65収納代行請求先名(カナ)
      "", # 66収納代行問合せ先名(漢字)
      "", # 67収納代行問合せ先郵便番号
      "", # 68収納代行問合せ先住所
      "", # 69収納代行問合せ先住所（アパートマンション名）
      "", # 70収納代行問合せ先電話番号
      "", # 71収納代行管理番号
      "", # 72収納代行品名
      "", # 73収納代行備考
      "", # 74複数口くくりキー
      "", # 75検索キータイトル1
      "", # 76検索キー1
      "", # 77検索キータイトル2
      "", # 78検索キー2
      "", # 79検索キータイトル3
      "", # 80検索キー3
      "", # 81検索キータイトル4
      "", # 82検索キー4
      "", # 83検索キータイトル5
      "", # 84検索キー5
      "", # 85予備
      "", # 86予備
      "", # 87投函予定メール利用区分
      "", # 88投函予定メールe-mailアドレス
      "", # 89投函予定メールメッセージ
      "", # 90投函完了メール（お届け先宛）利用区分
      "", # 91投函完了メール（お届け先宛）e-mailアドレス
      "", # 92投函完了メール（お届け先宛）メールメッセージ
      "", # 93投函完了メール（ご依頼主宛）利用区分
      "", # 94投函完了メール（ご依頼主宛）e-mailアドレス
      "", # 95投函完了メール（ご依頼主宛）メールメッセージ
    ]
  end
end

File.delete("temporary.csv")

p "#{@index}件登録"
