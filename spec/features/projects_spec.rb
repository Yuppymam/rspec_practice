require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  scenario 'ユーザーは新しいプロジェクトを作成する' do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    expect { create_project }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario 'ユーザーはプロジェクトを編集する' do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    create_project

    expect {
      click_link 'Edit'
      fill_in 'Name', with: 'New Test Project'
      click_button 'Update Project'
    }.to_not change(user.projects, :count)

    aggregate_failures do
      expect(page).to have_content 'Project was successfully update'
      expect(page).to have_content 'New Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario 'ゲストはプロジェクトを追加できない' do
    visit projects_path
    expect(page).to have_content 'Log in'
  end

  scenario 'ユーザーはプロジェクトを完了済みにする' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    sign_in user

    visit project_path(project)

    expect(page).to_not have_content 'Completed'

    click_button 'Complete'

    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content 'Congratulations, this project is complete!'
    expect(page).to have_content 'Completed'
    expect(page).to_not have_button 'Complete'
  end

  def create_project
    click_link 'New Project'
    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Trying out Capybara'
    click_button 'Create Project'
  end
end
