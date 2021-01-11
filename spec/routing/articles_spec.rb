require 'rails_helper'

describe "Articles routes" do
    it 'should route to articles index' do
        expect(get '/articles').to route_to('articles#index')  
    end
    
end
