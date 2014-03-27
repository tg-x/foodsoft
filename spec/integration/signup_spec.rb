require_relative '../spec_helper'

# this feature only makes sense when the signup plugin is enabled
if defined? FoodsoftSignup
  describe 'the signup plugin', :type => :feature do

    before do
      FoodsoftConfig.config[:signup] = true
      FoodsoftConfig.config[:unapproved_allow_access] = nil
      FoodsoftConfig.config[:ordergroup_approval_payment] = nil
    end

    describe 'its signup page', :type => :feature do
      it 'is accessible when enabled' do
        get signup_path
        expect(response).to be_success
      end

      it 'is not accessible when disabled' do
        FoodsoftConfig.config[:signup] = false
        get signup_path
        expect(response).to_not be_success
      end

      it 'is not accessible without key when protected' do
        FoodsoftConfig.config[:signup] = 'abcdefgh'
        get signup_path
        expect(response).to_not be_success
      end

      it 'is accessible with key when protected' do
        FoodsoftConfig.config[:signup] = 'abcdefgh'
        get signup_path(key: FoodsoftConfig.config[:signup])
        expect(response).to be_success
      end

      it 'can create a new user and unapproved ordergroup' do
        visit signup_path
        user = build :_user
        ordergroup = build :ordergroup
        fill_in 'user_nick', :with => user.nick if FoodsoftConfig[:use_nick]
        fill_in 'user_first_name', :with => user.first_name
        fill_in 'user_last_name', :with => user.last_name
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        fill_in 'user_password_confirmation', :with => user.password
        fill_in 'user_phone', :with => user.phone
        fill_in 'user_ordergroup_contact_address', :with => Faker::Address.street_address
        find('input[type=submit]').click
        expect(page).to have_selector('.alert-success')
        newuser = User.find_by_email(user.email)
        expect(newuser).to_not be_nil
        expect(newuser.id).to_not be_nil
        expect(newuser.ordergroup).to_not be_nil
        expect(newuser.ordergroup.approved?).to be_false
      end
    end


    describe :type => :feature do
      let(:order) { create :order }
      let(:ordergroup) { create :ordergroup, :user_ids => [user.id], :approved => false }
      let(:user) { create :_user }
      before { ordergroup; login user }

      it 'disallows ordering when not approved' do
        visit new_group_order_path(:order_id => order.id)
        expect(page).to have_selector('.alert-error')
        expect(current_path).to eq root_path
      end

      it 'allows ordering when approved' do
        ordergroup.approved = true
        ordergroup.save!
        visit new_group_order_path(:order_id => order.id)
        expect(page).to_not have_selector('.alert-error')
      end
    end

  end
end
