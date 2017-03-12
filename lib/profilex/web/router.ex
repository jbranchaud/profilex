defmodule Profilex.Web.Router do
  use Profilex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Profilex.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create

    resources "/accounts", AccountController
  end
end
