defmodule MementhoWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", MementhoWeb.RoomChannel
  channel "user:*", MementhoWeb.UserChannel

  ## Transports
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do 
  require Logger
    case Guardian.Phoenix.Socket.authenticate(socket, Mementho.Accounts.Guardian, token) do
      {:ok, authed_socket} ->
        Logger.info "User connected"
        {:ok, authed_socket}
      {:error, error} -> 
        Logger.info "Random user connected"
        {:ok, socket}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MementhoWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
