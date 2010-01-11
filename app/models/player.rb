class Player < ActiveRecord::Base
  has_one :stat, :class_name => 'PlayerStat'

  named_scope :name_like, lambda {|name| {:conditions => ["full_name like ?", name.gsub('*', '%')]} }

  def self.find_or_create full_name, rank
    player = find_by_full_name(full_name)
    unless player
      player = create!(:full_name => full_name, :rank => rank)
    end
    player
  end

  def self.search name
    result = self
    result = result.name_like(name) unless name.blank?
    result = result.include(:stat)
  end
end
