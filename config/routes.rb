DonutTracker::Application.routes.draw do
  
  get "posts/index"
  root to: "posts#index"
  
  get "/:search", controller: "posts", action: "index"
  
end
