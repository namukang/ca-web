class CreateFailedSignups < ActiveRecord::Migration
  def change
    create_table :failed_signups do |t|
      t.string :email

      t.timestamps
    end
  end
end
