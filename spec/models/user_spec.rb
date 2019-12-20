# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '姓、名、メール、パスワードがあれば有効な状態である' do
    user = User.new(
      first_name: 'Asron',
       last_name: 'Sumner',
           email: 'tester@example.com',
        password: 'dottle-nouveau-pavilion-tights-furze'
    )
    expect(user).to be_valid
  end

  it '名がなければ無効な状態である'

  it '姓がなければ無効な状態である'

  it 'メールアドレスがなければ無効な状態である'

  it '重複したメールアドレスなら無効な状態である'

  it 'ユーザーのフルネームを文字列として返す'
end
