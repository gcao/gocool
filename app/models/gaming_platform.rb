# coding: utf-8
class GamingPlatform < ActiveRecord::Base

  ALL = 999

  default_scope :order => 'name'
  
  def self.kgs
    @kgs ||= self.find_by_name('KGS')
  end

  def self.dgs
    @dgs ||= self.find_by_name('DGS')
  end

  def self.tom
    @tom ||= self.find_by_name('TOM')
  end

  def self.igs
    @igs ||= self.find_by_name('IGS')
  end

  def self.sina
    @sina ||= self.find_by_name('新浪')
  end

  def self.eweiqi
    @eweiqi ||= self.find_by_name('弈城')
  end

  def self.qiren
    @qiren ||= self.find_by_name('棋人')
  end

  def link_html
    url = self.url
    url = "http://" + url unless url =~ /html\:/
    "<a href='#{url}' target='_new'>#{name}</a>"
  end
end
