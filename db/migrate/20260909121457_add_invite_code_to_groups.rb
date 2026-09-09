class AddInviteCodeToGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :groups, :invite_code, :string
  end
end
