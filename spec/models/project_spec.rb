require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'プロジェクト名があれば有効な状態である' do
    project = @user.projects.create(name: 'Test Project')
    expect(project).to be_valid
  end

  it 'プロジェクト名がなければ無効な状態である' do
    project = @user.projects.create(name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it 'ユーザー単位では重複したプロジェクト名を許可しないこと' do
    @user.projects.create(
      name: 'Test Project'
    )

    new_project = @user.projects.build(
      name: 'Test Project'
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  it '二人のユーザーが同じ名前を使うことは許可すること' do
    @user.projects.create(
      name: 'Test Project'
    )

    other_user = User.create(
      first_name: 'Jane',
       last_name: 'Tester',
           email: 'janetester@example.com',
        password: 'dottle-nouveau-pavilion-tights-furze'
    )

    other_project = other_user.projects.build(
      name: 'Test Project'
    )

    expect(other_project).to be_valid
  end

  describe '遅延ステータス' do
    it '締切日が過ぎていれば遅延していること' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it '締切日が今日ならスケジュール通りであること' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it '締切日が未来ならスケジュール通りであること' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it 'たくさんのメモがついていること' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
