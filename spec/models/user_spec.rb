require 'rails_helper'

describe User do
  it { is_expected.to have_many(:companies) }
  it { is_expected.to have_many(:friends).dependent(true) }
  it { is_expected.to have_many(:reviews).dependent(true) }
  it { is_expected.to have_many(:votes).dependent(true) }
  it { is_expected.to have_many(:messages).dependent(true) }

  # validations
  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to validate_presence_of(:role) }

  describe '#num_of_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:friend_2)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }

    it 'gets the sum of all friends for curren user' do
      expect(user.num_of_friends).to eq(2)
    end
  end

  describe '#num_of_pending_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:friend_2)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }

    it 'gets the sum of all pending friends for curren user' do
      expect(user.num_of_pending_friends).to eq(1)
    end
  end

  describe '#num_of_blocked_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:friend_2)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }
    let!(:blocked_2) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }


    it 'gets the sum of all blocked friends for curren user' do
      expect(user.num_of_blocked_friends).to eq(2)
    end
  end

  describe '#all_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:friend_2)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }

    it 'gets  friends for current user' do
      expect(user.all_friends.count).to eq(2)
    end
  end

  describe '#pending_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }

    it 'gets pending friends for current user' do
      expect(user.pending_friends.count).to eq(1)
    end
  end

  describe '#blocked_friends' do
    let!(:user)      { Fabricate(:user) }
    let!(:friend_1)  { Fabricate(:friend, user_id: user.id) }
    let!(:pending_1) { Fabricate(:friend, user_id: user.id, pending: true, a_friend: false) }
    let!(:blocked_1) { Fabricate(:friend, user_id: user.id, user_blocked: true, a_friend: false) }

    it 'returns blocked friends for current user' do
      expect(user.blocked_friends.count).to eq(1)
    end
  end

  describe '#blocked?(current_user)' do
    let!(:user)         { Fabricate(:user) }
    let!(:friend_1)     { Fabricate(:user) }
    let!(:friend_2)     { Fabricate(:user) }
    let!(:friendship_1) { Fabricate(:friend,
                                    user_id: friend_1.id,
                                    user_blocked: true,
                                    id_of_friend: user.id,
                                    a_friend: true) }

    let!(:friendship_2) { Fabricate(:friend,
                                    user_id: friend_2.id,
                                    user_blocked: false,
                                    id_of_friend: user.id,
                                    a_friend: true) }

    it 'returnes true if frend blocked user' do
      expect(user.blocked_by?(friend_1)).to be true
    end

    it 'returnes false if friend did not bocked the user' do
      expect(user.blocked_by?(friend_2)).to be false
    end
  end
end
