# == Schema Information
#
# Table name: logs
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  log_level     :integer
#  message       :text
#  loggable_type :string
#  loggable_id   :integer
#

class LogsController < ApplicationController
  def index
    respond_with_params logs
  end

  private

  def logs
    @_logs ||= query_with Log.where(loggable_type: params[:loggable_type], loggable_id: params[:loggable_id]), :pagination
  end
end
