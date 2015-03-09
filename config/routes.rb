#Viewmaster::Engine.routes.draw do
Rails.application.routes.draw do 


  resource :looks do 
    collection do 
      get "switch_to/:id" => "viewmaster/looks#switch_to" , as: "switch"
      #, constraints: { id: /#{Regexp.escape(Viewmaster::Config.layouts.join('|'))}/ }
    end
  end

end
