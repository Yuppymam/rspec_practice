require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it { is_expected.to have_attached_file(:attachment) }

  it 'ユーザー、プロジェクト、メッセージがあれば有効な状態である' do
    note = Note.new(
      message: 'This is a sample note.',
         user: user,
      project: project
    )
    expect(note).to be_valid
  end

  it 'メッセージがなければ無効な状態である' do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe '文字列に一致するメッセージを検索する' do
    let!(:note1) {
      FactoryBot.create(:note,
                        project: project,
                           user: user,
                        message: 'This is the first note.')
    }

    let!(:note2) {
      FactoryBot.create(:note,
                        project: project,
                           user: user,
                        message: 'This is the second note.')
    }

    let!(:note3) {
      FactoryBot.create(:note,
                        project: project,
                           user: user,
                        message: 'First, preheat the oven.')
    }

    context '一致するデータが見つかるとき' do
      it '検索文字列に一致するメモを返す' do
        expect(Note.search('first')).to include(note1, note3)
        expect(Note.search('first')).to_not include(note2)
      end
    end

    context '一致するデータが1件も見つからないとき' do
      it '空のコネクションを返す' do
        expect(Note.search('message')).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

  it '名前の取得をメモを作成したユーザーに委譲すること' do
    user = instance_double('User', name: 'Fake User')
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq 'Fake User'
  end
end
