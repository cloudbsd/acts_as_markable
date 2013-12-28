class ActsAsMarkableMigration < ActiveRecord::Migration
  def change
    create_table :marks, :force => true do |t|
      t.belongs_to :marker, polymorphic: true, :null => false, index: true
      t.belongs_to :markable, polymorphic: true, :null => false, index: true
      t.string  :action, :null => false

      t.timestamps
    end
  end
end
