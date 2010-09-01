class Admin::BaseController < ApplicationController
  before_filter :set_admin_flag

  def set_admin_flag
    @admin_page = true
  end
  
  def self.common_setup config
    config.show.link         = false
    config.search.link.label = I18n.t('form.search_button')
    config.create.link.label = I18n.t('form.create_button')
    config.update.link.label = I18n.t('form.edit_button')
    config.delete.link.label = I18n.t('form.delete_button')
  end
end
