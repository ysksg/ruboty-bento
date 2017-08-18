require "ruboty"
require "ruboty/bento/version"
require 'nokogiri'
require 'open-uri'
require 'date'

module Ruboty
  module Handlers
    class Bento < Base
      on(
        /bento (?<vendor>.*?)\z/,
        name: 'bento',
        description: 'get the lunchbox menu'
      )

      def bento(message)
        case message[:vendor]
        when "azuma" then
          message.reply("*今日のメニュー（あづま給食）* \n>>>" + get_azuma_menu)
        when "tamagoya" then
          message.reply("*今日のメニュー（玉子屋）* \n>>>" + get_tamagoya_menu)
        else
          message.reply("*今日のメニュー（あづま給食）* \n>>>" + get_azuma_menu)
          message.reply("*今日のメニュー（玉子屋）* \n>>>" + get_tamagoya_menu)
        end
      end

      # ------------------------------------------------------ #

      def get_azuma_menu
        url = 'http://azuma-catering.com/lunch.php'
        charset = "utf-8"

        # html読み込み
        html = open(url).read
        doc = Nokogiri::HTML.parse(html, nil, charset)

        today_menu_element = doc.css('div.lunch_contents')

        menu = today_menu_element.css('li').map{|m| m.text}.join("\n")
        cal = today_menu_element.css('div.lunch_cal').text

        return menu + "\n" + cal
      end

      # ------------------------------------------------------ #

      def get_tamagoya_menu
        url = 'http://www.tamagoya.co.jp/menu.html'
        charset = "utf-8"

        # html読み込み
        html = open(url).read
        doc = Nokogiri::HTML.parse(html, nil, charset)

        menu_index = 0
        # div要素のmenu_titleクラスを抽出し，今日が何個目の要素に入っているかを検索
        doc.css('div.menu_title').each do |menu_title|
          if menu_title.text.include?(Date.today.day.to_s+"日")
            break
          end
          menu_index += 1
        end

        # 全日のメニューを取得
        all_menu_element = doc.css('div.menu_list')

        if menu_index >= all_menu_element.size
          return "指定された日時のメニューは存在しません"
        else
          # 今日のメニュー&カロリー情報を取得	
          today_menu_element = all_menu_element[menu_index]

          menu = today_menu_element.css('li').map{|m| m.text}.join("\n")
          cal = today_menu_element.css('p.menu_calorie').text

          return menu + "\n" + cal
        end
      end

      # ------------------------------------------------------ #

    end
  end
end
