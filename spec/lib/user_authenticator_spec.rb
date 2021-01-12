require 'rails_helper'

describe UserAuthenticator do
    describe "#perform" do
        let(:authenticator) { described_class.new('sample_code')}
        subject { authenticator.perform }

        context "when the code is invalid" do
            let(:error){
                double("Sawyer::Resource", error: "bad_verification_code")
            }

            before do
                allow_any_instance_of(Octokit::Client).to receive(
                    :exchange_code_for_token).and_return(error) 
            end

            it "should raise an error" do
                expect{subject}.to raise_error(
                    UserAuthenticator::AuthenticationError
                )  
                expect(authenticator.user).to be_nil  
            end 
        end

        context "when the code is valid" do
            let(:user_data) do
                {
                    login: 'jsmith1',
                    url: 'http://example.com',
                    avatar_url: 'http://example.com/avatar',
                    name: 'john smith'
                }
            end
            before do
                allow_any_instance_of(Octokit::Client).to receive(
                    :exchange_code_for_token).and_return('validaccesstoken') 
                allow_any_instance_of(Octokit::Client).to receive(
                    :user).and_return(user_data) 
            end

            it "should register a new user" do
                expect{subject}.to change{ User.count }.by(1)
                expect(User.last.name).to eq('john smith')
            end 

            it "should reuse already register user" do
                user = create :user, user_data
                expect { subject }.not_to change { User.count }
                expect(authenticator.user).to eq(user)
            end 
        end
    end
end