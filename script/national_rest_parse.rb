require 'open-uri'
require 'iconv'

def get_national_forest
  hosts = [["0113", "가리왕산(정선)"], ["0184", "검마산(영양)"], ["0244", "검봉산(삼척)"], ["0200", "낙안민속(순천)"], ["0192", "남해편백(남해)"], ["0111", "대관령(강릉)"], ["0245", "대야산(문경)"], ["0141", "덕유산(무주)"], ["0243", "두타산(평창)"], ["0112", "미천골(양양)"], ["0181", "방장산(장성)"], ["0109", "방태산(인제)"], ["0223", "백운산(원주)"], ["0189", "변산(부안)"], ["0110", "복주산(철원)"], ["0105", "신불산(울주)"], ["0103", "산음(양평)"], ["0107", "삼봉(홍천)"], ["0300", "상당산성(청주)"], ["0115", "속리산(보은)"], ["0191", "오서산(보령)"], ["0102", "용대(인제)"], ["0220", "용현(서산)"], ["0222", "용화산(춘천)"], ["0195", "운문산(청도)"], ["0224", "운악산(포천)"], ["0194", "운장산(진안)"], ["0101", "유명산(가평)"], ["0108", "중미산(양평)"], ["0190", "지리산(함양)"], ["0196", "천관산(장흥)"], ["0183", "청옥산(봉화)"], ["0106", "청태산(횡성)"], ["0182", "칠보산(영덕)"], ["0193", "통고산(울진)"], ["0242", "황정산(단양)"], ["0188", "회문산(순창)"], ["0187", "희리산(서천)"]]
  room_types = [03001, 03002, 04002, 04005]

  parse_url = "http://www.huyang.go.kr/reservation/reservationMonthSearch.action"
  url = "http://www.huyang.go.kr/reservation/reservationMonthSearch.action?useBgnDtm=20130601&dprtm=0113&fcltMdcls=03001&availMonth=201506"
  header = { cookie: 'elevisor_for_j2ee_uid=-9035965834960077555; ACEFCID=UID-558B7C224981A42576CEAE35; JSESSIONID=hwoTx6xUzG22+cN35tKj-+oX.node05_1' }

  hosts.each do |id, name|
    room_types.each do |room_type|
      params = { availMonth: YYMM, dprtm: id.to_i, fcltMdcls: room_type, useBgnDtm: 20130601 }
      content = RestClient.post(parse_url, params, header)
      doc = Nokogiri::HTML(content)
    end
  end
end



def get_rsa_keys
  url = RestClient::Request.execute(
    :url => "https://www.huyang.go.kr/member/memberLogin.action",
    :method => :get,
    :verify_ssl => false,
    :headers => {
      :referer => 'https://www.huyang.go.kr/main.action'
    }
  )
  doc = Nokogiri::HTML(url)

  rsaPublicKeyModulus= doc.css("[id='rsaPublicKeyModulus']")
  rsaPublicKeyExponent= doc.css("[id='rsaPublicKeyExponent']")
  puts [rsaPublicKeyModulus, rsaPublicKeyExponent]

  url = RestClient::Request.execute(
    url: "https://www.huyang.go.kr/member/memberLogin.action",
    method: :post,
    verify_ssl: false,
    payload: {
      RSA: "RSA",
      mmberId: "",
      mmberPassword: "",
      referer: 'https://www.huyang.go.kr/main.action'
    },
    headers: {
      referer: 'https://www.huyang.go.kr/main.action'
    }
  )

end

get_rsa_keys()
