# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  type        :string           not null
#  name        :string           not null
#  description :text
#  value       :text
#  value_type  :integer          default(0)
#  default     :text
#
# Indexes
#
#  index_settings_on_type  (type)
#

class SettingsController < ApplicationController
  after_action :verify_authorized

  api :GET, '/settings', 'Get all settings in the system'
  def index
    authorize Setting
    respond_with settings, each_serializer: SettingSerializer
  end

  api :PUT, '/settings/:name', 'Update a setting value'
  param :name, String, desc: 'Setting name', required: true
  param :value, String, desc: 'Setting value replacement', required: true
  def update
    setting.update value: params[:value]
    respond_with setting, serializer: SettingSerializer
  end

  private

  def settings
    @_settings ||= Setting.all
  end

  def setting
    @_setting ||= Setting.find_by(name: params[:name]).tap { |s| authorize s }
  end
end
