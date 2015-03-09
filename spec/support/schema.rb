require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
#ActiveRecord::Base.logger = Logger.new(SPEC_ROOT.join('debug.log'))
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
    t.string :last_name
    t.string :email
    t.string :layout
    t.timestamps
  end
  create_table :general_models do |t|
    t.references :user, index: true
    t.string :name
    t.text :settings
    t.integer :position
    t.timestamps
  end

end

