class Player < ActiveRecord::Base
  has_one :stat, :class_name => 'PlayerStat'

  # has_many :opponent_stat, :class_name => "PairStat"

  named_scope :name_like, lambda {|name| {:conditions => ["full_name like ?", name.gsub('*', '%')]} }

  named_scope :with_stat, :include => :stat

  def self.find_or_create full_name, rank
    player = find_by_full_name(full_name)
    unless player
      player = create!(:full_name => full_name, :rank => rank)
      PlayerStat.create!(:player_id => player.id)
    end
    player
  end

  def self.search name
    result = self
    result = result.name_like(name) unless name.blank?
    result = result.include(:stat)
  end
end
