# coding: utf-8
module CoolGames
  class GamingPlatform
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name       , type: String
    field :url        , type: String
    field :description, type: String
    field :turn_based , type: Boolean
    field :updated_by , type: String

    ALL = 999

    default_scope order_by([[:name]])

    def self.kgs
      @kgs ||= self.find_by(name:'KGS')
    end

    def self.dgs
      @dgs ||= self.find_by(name:'DGS')
    end

    def self.tom
      @tom ||= self.find_by(name:'TOM')
    end

    def self.igs
      @igs ||= self.find_by(name:'IGS')
    end

    def self.sina
      @sina ||= self.find_by(name:'Sina')
    end

    def self.eweiqi
      @eweiqi ||= self.find_by(name:'eWeiqi')
    end

    def self.gocool
      @gocool ||= self.find_by(name:'Gocool')
    end

    def link_html
      url = self.url
      url = "http://" + url unless url =~ /html\:/
      "<a href='#{url}' target='_new'>#{name}</a>"
    end
  end
end
