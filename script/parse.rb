require 'open-uri'
require 'iconv'

hosts = Host.all
now = Time.now
YEAR = now.year
MONTH = now.month
YYMMDD = now.strftime("%Y%m%d")

def get_type_one
  # TYPE 1
  Host.where(parse_type: 1).each do |host|
    puts "-- Parsing... #{host.name}"
    url = open("#{host.parse_url}?f_year=#{YEAR}&f_month=#{MONTH}")
    doc = Nokogiri::HTML(url, nil, 'euc-kr')
    rows = doc.css("[width='744']").css("[bgcolor='dad3c9']").css("tr")
    rows.each do |row|
      titles = row.css("td[width='140']").xpath('text()')
      next unless titles.present?

      room_name = titles.first.text
      guest_count = if m = room_name.match(/(\d+)명/)
                      m.captures.first.to_i
                    else
                      nil
                    end

      room = Room.find_or_create_by(host: host, name: room_name, guest: guest_count)

      cols = row.css("td[width='15']")
      cols.each_with_index do |col, index|
        is_possible = (col.css('form').present? ? true : false)
        day = index + 1

        schedule = Schedule.eager_load(:room).find_or_create_by({
          year: YEAR, room: room, host: host, month: MONTH, day: day
        })

        schedule.update!(reserved: !is_possible) if schedule.reserved == nil || schedule.reserved? != !is_possible
      end
    end
  end
end

def get_type_two
  # TYPE 2 - with post method(거제, 안면도 자연휴양림)
  Host.where(parse_type: 2, id: 4).each do |host|
    puts "-- Parsing... #{host.name}"
    header = { referer: host.parse_url, cookie: 'ASPSESSIONIDQQDQDSCC=LBMMALCCHJKFMPGGJDGCEEPE' }
    puts host.parse_url
    content = RestClient.post host.parse_url, { wh_year: YEAR, wh_month: MONTH, x: 14, y: 12 }, header
    doc = Nokogiri::HTML(content, 'euc-kr')

    rows = doc.css("[class='calendar'] table tbody tr")
    rows.each do |row|
      titles = row.css("td[scope='row']").xpath('text()')
      next unless titles.present?

      room_name = titles.first.text
      guest_count = if m = room_name.match(/(\d+)명/)
                      m.captures.last.to_i
                    else
                      nil
                    end

      room = Room.find_or_create_by(host: host, name: room_name, guest: guest_count)

      cols = row.css("td")
      cols.each_with_index do |col, day|
        next if day == 0

        is_possible = (col.css('form').present? ? true : false)

        schedule = Schedule.eager_load(:room).find_or_create_by({
          year: YEAR, room: room, host: host, month: MONTH, day: day
        })

        schedule.update!(reserved: !is_possible) if schedule.reserved == nil || schedule.reserved? != !is_possible
      end
    end
  end
end


def get_type_three
  # TYPE 2 - with post method(거제, 안면도 자연휴양림)
  Host.where(parse_type: 3).each do |host|
    puts "-- Parsing... #{host.name}"
    header = { referer: host.parse_url, cookie: 'ASPSESSIONIDQQDQDSCC=LBMMALCCHJKFMPGGJDGCEEPE' }
    content = RestClient.post host.parse_url, { wh_year: YEAR, wh_month: MONTH, x: 14, y: 12 }, header
    doc = Nokogiri::HTML(content, 'euc-kr')

    rows = doc.css("[class='calendar'] tbody tr")
    rows.each do |row|
      cols = row.css("td")
      cols.each do |col|
        day = col.children.first.text.to_i
        p "-- #{day}"
        next if day < 1

        rooms = col.css("form")
        rooms.each do |room|
          room_name = room.text
          room = Room.find_or_create_by(host: host, name: room_name)
          schedule = Schedule.find_or_create_by({
            year: YEAR, room: room, host: host, month: MONTH, day: day
          })
        end
      end
    end

  end
end


def get_national_forest
  hosts = [["0113", "가리왕산(정선)"], ["0184", "검마산(영양)"], ["0244", "검봉산(삼척)"], ["0200", "낙안민속(순천)"], ["0192", "남해편백(남해)"], ["0111", "대관령(강릉)"], ["0245", "대야산(문경)"], ["0141", "덕유산(무주)"], ["0243", "두타산(평창)"], ["0112", "미천골(양양)"], ["0181", "방장산(장성)"], ["0109", "방태산(인제)"], ["0223", "백운산(원주)"], ["0189", "변산(부안)"], ["0110", "복주산(철원)"], ["0105", "신불산(울주)"], ["0103", "산음(양평)"], ["0107", "삼봉(홍천)"], ["0300", "상당산성(청주)"], ["0115", "속리산(보은)"], ["0191", "오서산(보령)"], ["0102", "용대(인제)"], ["0220", "용현(서산)"], ["0222", "용화산(춘천)"], ["0195", "운문산(청도)"], ["0224", "운악산(포천)"], ["0194", "운장산(진안)"], ["0101", "유명산(가평)"], ["0108", "중미산(양평)"], ["0190", "지리산(함양)"], ["0196", "천관산(장흥)"], ["0183", "청옥산(봉화)"], ["0106", "청태산(횡성)"], ["0182", "칠보산(영덕)"], ["0193", "통고산(울진)"], ["0242", "황정산(단양)"], ["0188", "회문산(순창)"], ["0187", "희리산(서천)"]]
  room_types = [03001, 03002, 04002, 04005]

  parse_url = "http://www.huyang.go.kr/reservation/reservationMonthSearch.action"
  url = "http://www.huyang.go.kr/reservation/reservationMonthSearch.action?useBgnDtm=20130601&dprtm=0113&fcltMdcls=03001&availMonth=201506"
  hosts.each do |id, name|
    room_types.each do |room_type|
      content = RestClient.post(parse_url, { dprtm: id.to_i, fcltMdcls: MONTH, availMonth: YYMMDD })
      doc = Nokogiri::HTML(content)
      puts doc
    end
  end
end

#get_type_one
#get_type_two
get_type_three
#get_type_four
#get_national_forest
