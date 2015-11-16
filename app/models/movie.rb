class Movie < ActiveRecord::Base

  def self.all_ratings
    self.uniq.pluck(:rating)
  end
end
