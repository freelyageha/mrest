require 'open-uri'
require 'iconv'

hosts = Host.all
YEAR = Time.now.year
MONTH = Time.now.month

def get_type_one
  # TYPE 1
  Host.where(parse_type: 1).each do |host|
    url = open("#{host.parse_url}?f_year=#{YEAR}&f_month=#{MONTH}")
    doc = Nokogiri::HTML(url, nil, 'euc-kr')
    rows = doc.css("[width='744']").css("[bgcolor='dad3c9']").css("tr")
    rows.each do |row|
      titles = row.css("td[width='140']").xpath('text()')
      next unless titles.present?

      room_name = titles.first.text
      room = Room.find_or_create_by(name: room_name)

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
  # TYPE 2 - with post method(거제)
  Host.where(parse_type: 2).each do |host|
    header = { referer: host.parse_url }
    content = RestClient.post host.parse_url, { wh_year: YEAR, wh_month: MONTH, x: 14, y: 12 }, header
    doc = Nokogiri::HTML(content)

    rows = doc.css("[class='calendar'] table tbody tr")
    rows.each do |row|
      titles = row.css("td[scope='row']").xpath('text()')
      next unless titles.present?

      room_name = titles.first.text
      room = Room.find_or_create_by(host: host, name: room_name)

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


get_type_one
get_type_two
