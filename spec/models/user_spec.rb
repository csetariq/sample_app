require 'spec_helper'

describe User do
	before { @user = User.new name: "Tariq", email: "csetariq@gmail.com",
														password:	"foobar",	password_confirmation:	"foobar" }

	subject { @user }

	it { should respond_to :name }
	it { should respond_to :email }
	it { should respond_to :password_digest }
	it { should respond_to :password}
	it { should respond_to :password_confirmation}
	
	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51}
		it { should_not be_valid }
	end

	describe "when name is too short" do
		before { @user.name = "a"}
		it { should_not be_valid }
	end

	describe "when email is valid" do
		it "should be valid" do
			@user.email = "csetariq@gmail.co"
			@user.should be_valid
		end
	end

	describe "when email is invalid" do
		it "should be invalid" do 
			@user.email = "csetariqgmail.co.in"
			@user.should_not be_valid
		end
	end
	
	describe "when the email is already taken" do
		before do
			dup_user = @user.dup
			dup_user.save
		end

		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when the password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authentication method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid password") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

end
