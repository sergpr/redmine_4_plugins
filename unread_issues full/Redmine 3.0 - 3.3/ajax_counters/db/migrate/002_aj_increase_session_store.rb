class AjIncreaseSessionStore < ActiveRecord::Migration
  def change
    change_column :sessions, :data, :text, limit: 16777214
  end
end