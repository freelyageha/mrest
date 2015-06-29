require 'open-uri'
require 'iconv'

def get_type_one(year, month)
  # 소선암, 축령산
  Host.where(parse_type: 1).each do |host|
    host.parse_url.each do |u|
      puts "# -- Parsing... #{host.name} - #{u}"
      url = open("#{u}f_year=#{year}&f_month=#{month}")
      doc = Nokogiri::HTML(url, nil, 'euc-kr')
      rows = doc.css("table[width='744'] tr")
      rows.each_with_index do |row, i|
        cols = row.css("td")
        next if cols.size < 30 || cols.size > 35

        room_name = cols.first.text
        next if room_name.match(/시설/)
        next unless room_name.present?

        guest_count = if m = room_name.match(/(\d+)명/)
                        m.captures.first.to_i
                      else
                        nil
                      end
        room_name = room_name
          .gsub(/\(.*$/, "").gsub(/\d+.*$/, "").gsub(/\s+/, "")

        puts "# #{room_name}"
        room = Room.find_or_create_by(host: host, name: room_name, guest: guest_count)
        cols.each_with_index do |col, index|
          next if index == 0

          reserved = (col.css('form').present? ? false : true)
          day = index + 1

          schedule = Schedule.eager_load(:room).find_or_create_by({
            year: year, room: room, host: host, month: month, day: day
          })

          schedule.update!(reserved: reserved) if schedule.reserved == reserved
        end
      end
    end
  end
end


def get_type_two(year, month)
  # 거제
  Host.where(parse_type: 2).each do |host|
    host.parse_url.each do |u|
      header = { referer: u, cookie: 'ASPSESSIONIDQQDQDSCC=LBMMALCCHJKFMPGGJDGCEEPE' }
      puts "-- Parsing... #{host.name} - #{u}"
      content = RestClient.post(u, { wh_year: year, wh_month: month, x: 14, y: 12 }, header)
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

        room_name = room_name.gsub(/\s+.*$/, "")
        puts "# #{room_name}"
        room = Room.find_or_create_by(host: host, name: room_name, guest: guest_count)

        cols = row.css("td")
        cols.each_with_index do |col, day|
          next if day == 0

          reserved = (col.css('form').present? ? false : true)
          schedule = Schedule.eager_load(:room).find_or_create_by({
            year: YEAR, room: room, host: host, month: MONTH, day: day
          })

          schedule.update!(reserved: reserved) if schedule.reserved == reserved
        end
      end
    end
  end
end


def get_type_three(year, month)
  # 안면도, 강씨봉
  Host.where(parse_type: 3).each do |host|
    # 시작전에 schedule reset 함(가능한 방만 parse하기 때문)
    Schedule.update_all(reserved: false, host_id: host.id)

    #cookies = RestClient.get(host.url).cookies
    #cookie = "#{cookies.keys.first}=#{cookies.values.first}"

    host.parse_url.each do |u|
      puts "-- Parsing... #{host.name} - #{u}"
      header = { referer: u, cookie: host.cookie }
      content = RestClient.post(u, { wh_year: year, wh_month: month, x: 14, y: 12 }, header)
      doc = Nokogiri::HTML(content, 'euc-kr')

      rows = doc.css("table tbody tr")
      rows.each do |row|
        cols = row.css("td")
        cols.each do |col|
          day = col.children.first.text.to_i
          next if day < 1

          rooms = col.css("form")
          rooms.each do |room|
            room_name = room.text.gsub("*", "")
            puts "# #{room_name}"
            room = Room.find_or_create_by(host: host, name: room_name)
            schedule = Schedule.find_or_create_by({
              year: YEAR, room: room, host: host, month: MONTH, day: day
            })
          end
        end
      end
    end
  end
end

def get_type_four(year, month)
  # 청평, 설매재
  Host.where(parse_type: 4).each do |host|
    host.parse_url.each do |u|
      _url = "#{u}year=#{year}&month=#{month}"
      puts "# -- #{host.name}"

      today = Time.now
      start_of_day = today.month == month ? today.day : 1
      end_of_day = Time.new("#{year}%2d01", month).end_of_month.day + 1

      (start_of_day...end_of_day).each do |day|
        puts "# -- #{month}/#{day}"
        url = open("#{_url}&day=#{day}")
        doc = Nokogiri::HTML(url, nil, 'euc-kr')
        rows = doc.css("table[width='620']")[1].css("td[width='310']").last.css("tr[height='23']")
        rows.each do |row|
          cols = row.css("td")
          room_name = cols.first.text
          reserved = cols.last.css("input").size > 0 ? false : true

          room = Room.find_or_create_by(host: host, name: room_name)
          schedule = Schedule.find_or_create_by({
            year: YEAR, room: room, host: host, month: MONTH, day: day
          })
          schedule.update!(reserved: reserved) if schedule.reserved != reserved
        end
      end
    end
  end
end

def get_type_five(year, month)
  # 천보산
  Host.where(parse_type: 5).each do |host|
    host.parse_url.each do |u|
      _url = "#{u}year=#{year}&month=#{month}"
      puts "# -- #{host.name}"

      today = Time.now
      start_of_day = today.month == month ? today.day : 1
      end_of_day = Time.new("#{year}%2d01", month).end_of_month.day + 1
      groups = ["netfu_257254846", "netfu_8_27230000", "netfu_3_73830205", "netfu_40019_79959", "netfu_5_77011918", "netfu_2_30281931"]

      groups.each do |group|
        (start_of_day...end_of_day).each do |day|
          puts "# -- #{month}/#{day}"
          url = open("#{_url}&day=#{day}&group=#{group}")
          doc = Nokogiri::HTML(url, nil, 'utf-8')
          rows = doc.css("[class='tf'] tr table tr[height='40']")
          rows.each do |row|
            cols = row.css("td")
            room_name = cols[1].text.gsub(/\s+/, "")
            puts "#-- #{room_name}"
            min, max = cols[2].text.split("/")
            size = cols[4].css("[class='num11']").text
            reserved = cols.last.css("[class='psr']").size > 0 ? false : true

            room = Room.find_or_create_by(host: host, name: room_name, size: size, guest: max)
            schedule = Schedule.find_or_create_by({
              year: YEAR, room: room, host: host, month: MONTH, day: day
            })
            schedule.update!(reserved: reserved) if schedule.reserved != reserved
          end
        end
      end
    end
  end
end

def get_type_six(year, month)
  '''
  <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:s="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <SOAP-ENV:Body>
      <tns:GetScheduleByGroup xmlns:tns="http://tempuri.org/">
        <tns:companyCode>0031</tns:companyCode>
        <tns:shopCode>0001</tns:shopCode>
        <tns:yearMonth>201506</tns:yearMonth>
      </tns:GetScheduleByGroup>
    </SOAP-ENV:Body>
  </SOAP-ENV:Envelope>
  '''

  client = Savon.client(
    wsdl: 'http://strawberry.mainticket.co.kr/C2Soft.Earth.Web.Service/FlexService.asmx?wsdl',
    soap_header: {
      Referer: 'https://strawberry.mainticket.co.kr/strawberry/Strawberry.swf',
      Origin: 'https://strawberry.maintickey.co.kr',
      Host: 'strawberry.mainticket.co.kr'
    }
  )

  #puts client.operations
  res = client.call(
    :get_schedule_by_group,
    message: { companyCode: "0031", shopCode: "0001", yearMonth: "201507" }
  )
  puts res.body

end


now = Time.now
YEAR = now.year
MONTH = now.month
YYMMDD = now.strftime("%Y%m%d")

#[MONTH, MONTH + 1].each do |month|
[MONTH].each do |month|
  #get_type_one(YEAR, month)
  #get_type_two(YEAR, month)
  #get_type_three(YEAR, month)
  #get_type_four(YEAR, month)
  #get_type_five(YEAR, month)
  get_type_six(YEAR, month)
end
