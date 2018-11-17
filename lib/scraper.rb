require 'open-uri'
require 'pry'

class Scraper


  def self.scrape_index_page(index_url)
    doc = open(index_url)
    student_list = Nokogiri::HTML(doc)

    students = []

    roster_cards = student_list.css(".student-card")
    roster_cards.each do |roster_card|
      hash = {
        name: roster_card.css(".student-name").text,
        location: roster_card.css(".student-location").text,
        profile_url: roster_card.css("a")[0]["href"]
      }
      students << hash
    end
    students
    end



  def self.scrape_profile_page(profile_url)
    doc = open(profile_url)
    student_profile = Nokogiri::HTML(doc)

    profile = {}
    social_icons = student_profile.css(".social-icon-container a")
    social_icons.each do |social_icon|
    link = social_icon.attribute("href").text
          profile[:twitter] = link if link.include?("twitter")
          profile[:linkedin] = link if link.include?("linkedin")
          profile[:github] = link if link.include?("github")
          profile[:blog] = link if social_icon.css("img").attribute("src").text.include?("rss")
end

    profile[:profile_quote] = student_profile.css("div.profile-quote").text
    profile[:bio] = student_profile.css("div.bio-content .description-holder p").text
    profile
  end
end
