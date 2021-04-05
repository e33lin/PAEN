class Survey < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :responses
  
  # https://stackoverflow.com/questions/7621322/ruby-find-next-thursday-or-any-day-of-the-week
  # 1. used to get current week's survey due date (Saturday)
  # 2. used to create the FIRST week's survey due date (Intialize a team)
  def self.get_current_survey_due_date(current_date) 
    if current_date.saturday?
        return current_date + 7
    else
        return 6 > current_date.wday ? current_date + (6 - current_date.wday) : current_date.next_week.next_day(6)
    end
  end
    
#   def survey_rating
#       rating = 100
#       "#{rating}"
# #       "#{rating}%"
#   end
end
