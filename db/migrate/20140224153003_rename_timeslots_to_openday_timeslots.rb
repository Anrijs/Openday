class RenameTimeslotsToOpendayTimeslots < ActiveRecord::Migration
  def change
  	rename_table :timeslots, :openday_timeslots
  end
end
