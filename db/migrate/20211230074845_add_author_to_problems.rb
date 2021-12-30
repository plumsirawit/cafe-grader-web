class AddAuthorToProblems < ActiveRecord::Migration
  def change
    add_reference :problems, :user, index: true, foreign_key: true
  end
end