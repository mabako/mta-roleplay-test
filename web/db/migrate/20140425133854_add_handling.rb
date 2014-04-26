class AddHandling < ActiveRecord::Migration
  def change
    create_table 'handlings' do |t|
      t.integer :year, null: false
      t.integer :price, null: false
      t.integer :model, null: false
      t.string :brand, null: false
      t.string :name, null: false
      t.integer :shop, null: false
      t.integer :disabled, limit: 1, null: false

      t.float :mass, null: false
      t.float :turnMass, null: false
      t.float :dragCoeff, null: false
      t.integer :percentSubmerged, null: false
      t.float :tractionMultiplier, null: false
      t.float :tractionLoss, null: false
      t.float :tractionBias, null: false
      t.integer :numberOfGears, null: false
      t.float :maxVelocity, null: false
      t.float :engineAcceleration, null: false
      t.float :engineInertia, null: false
      t.string :driveType, limit: 3, null: false
      t.string :engineType, limit: 10, null: false
      t.float :brakeDeceleration, null: false
      t.float :brakeBias, null: false
      t.float :steeringLock, null: false
      t.float :suspensionForceLevel, null: false
      t.float :suspensionDamping, null: false
      t.float :suspensionHighSpeedDamping, null: false
      t.float :suspensionUpperLimit, null: false
      t.float :suspensionLowerLimit, null: false
      t.float :suspensionFrontRearBias, null: false
      t.float :suspensionFrontRearBias, null: false
      t.float :suspensionAntiDiveMultiplier, null: false
      t.float :collisionDamageMultiplier, null: false

      t.timestamps
    end 
  end
end
