require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students_arr = []
    students = doc.css(".student-card").each do |student|
      student_data = {
        :name => student.css('.student-name').text,
        :location => student.css('.student-location').text,
        :profile_url => student.css('a').map {|link| link['href']}[0]
      }
      students_arr.push(student_data)
    end
    students_arr
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    links = doc.css('a').map {|link| link["href"]}
    student_info = {
      :twitter => links.find {|link| link.include?('twitter')},
      :linkedin => links.find {|link| link.include?('linkedin')},
      :github => links.find {|link| link.include?('github')},
      :blog => links[4],
      :profile_quote => doc.css(".profile-quote").text.strip,
      :bio => doc.css(".description-holder")[0].text.strip
    }
    student_info.select {|k, v| student_info[k] != nil}
  end

end

# profile_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/students/david-kim.html"
# Scraper.scrape_profile_page(profile_url)