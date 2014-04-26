class AddHandlingToVehicleAndCleanUp < ActiveRecord::Migration
  def change
    change_column_null :vehicles, :model, false
    change_column_null :vehicles, :x, false
    change_column_null :vehicles, :y, false
    change_column_null :vehicles, :z, false
    change_column_null :vehicles, :rotx, false
    change_column_null :vehicles, :roty, false
    change_column_null :vehicles, :rotz, false
    change_column_null :vehicles, :currx, false
    change_column_null :vehicles, :curry, false
    change_column_null :vehicles, :currz, false
    change_column_null :vehicles, :currrx, false
    change_column_null :vehicles, :currry, false
    change_column_null :vehicles, :fuel, false
    change_column_null :vehicles, :engine, false
    change_column_null :vehicles, :locked, false
    change_column_null :vehicles, :lights, false
    change_column_null :vehicles, :sirens, false
    change_column_null :vehicles, :paintjob, false
    change_column_null :vehicles, :hp, false
    change_column_null :vehicles, :color1, false
    change_column_null :vehicles, :color2, false
    change_column_null :vehicles, :faction, false
    change_column_null :vehicles, :owner, false
    change_column_null :vehicles, :job, false
    change_column_null :vehicles, :tintedwindows, false
    change_column_null :vehicles, :dimension, false
    change_column_null :vehicles, :interior, false
    change_column_null :vehicles, :currdimension, false
    change_column_null :vehicles, :currinterior, false
    change_column_null :vehicles, :enginebroke, false
    change_column_null :vehicles, :upgrades, false
    change_column_null :vehicles, :wheelStates, false
    change_column_null :vehicles, :panelStates, false
    change_column_null :vehicles, :odometer, false
    change_column_null :vehicles, :headlights, false
    change_column_null :vehicles, :Impounded, false
    change_column_null :vehicles, :handbrake, false

    change_column :vehicles, :plate, :string, null: false, limit: 8

    change_table :vehicles do |t|
      t.remove :items
      t.remove :itemvalues

      t.integer :handling, default: 0, null: false
    end
  end
end
