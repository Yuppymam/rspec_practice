require 'rails_helper'

describe User do
  it '有効なファクトリを持つこと' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }

  it { is_expected.to validate_presence_of :last_name }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it 'ユーザーのフルネームを文字列として返す' do
    user = FactoryBot.build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.name).to eq 'John Doe'
  end

  it 'アカウントが作成されたときにウェルカムメールを送信すること' do
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it 'performs geocoding', vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: '161.185.207.20')
    expect {
      user.geocode
    }.to change(user, :location)
      .from(nil)
      .to('Brooklyn, New York, US')
  end
end
