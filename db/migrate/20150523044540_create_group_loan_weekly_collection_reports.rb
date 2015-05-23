class CreateGroupLoanWeeklyCollectionReports < ActiveRecord::Migration
  def change
    create_table :group_loan_weekly_collection_reports do |t|
    	t.integer :server_id 
    	t.datetime :confirmed_at 

    	t.boolean :is_printed, :default => false 
    	t.datetime :print_date

      t.timestamps null: false
    end
  end
end
