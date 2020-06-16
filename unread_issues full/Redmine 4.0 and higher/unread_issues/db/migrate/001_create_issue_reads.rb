class CreateIssueReads < ActiveRecord::Migration[4.2]
  def change
    create_table :issue_reads do |t|
      t.integer :user_id
      t.integer :issue_id
      t.datetime :read_date
      t.timestamps
    end
  end
end
