require 'rails_helper'

RSpec.feature 'Notes', type: :feature do
  scenario 'ユーザーは新しいノートを作成できる', js: true do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'RSpec tutorial',
                               owner: user)

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_link 'RSpec tutorial'

    expect {
      click_link 'Add Note'
      fill_in 'Message', with: 'Test Note'
      click_button 'Create Note'

      expect(page).to have_content 'Note was successfully created'
      expect(page).to have_content 'Test Note'
      expect(page).to have_content "Owner: #{user.name}"
    }.to change(user.notes, :count).by(1)
  end
end
