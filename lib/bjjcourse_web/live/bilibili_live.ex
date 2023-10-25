defmodule BjjcourseWeb.BilibiliLive do
  use Phoenix.Component
  use Phoenix.LiveView
  import BjjcourseWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="container mx-auto h-screen">
      <div class="flex flex-row w-screen">
        <div class="flex-none w-200">
          <.table
            id="chapter"
            rows={@chapters}
            row_click={fn %{second: t} -> JS.push("location_start", value: %{value: t}) end}
          >
            <:col :let={chapter} label="chapter">
              <%= chapter.title %>
            </:col>
            <:col :let={chapter} label="start time"><%= chapter.start %></:col>
          </.table>
        </div>
        <div class="grow w-full">
          <iframe
            src={@video_url}
            scrolling="no"
            border="0"
            frameborder="no"
            framespacing="0"
            allowfullscreen="true"
          >
          </iframe>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    title = "pena下位拿背"

    table = [
      %{title: "Intro", start: "0", second: 0},
      %{title: "Primordial Details And Concepts - Intro", start: "1:08", second: 68},
      %{title: "Slide Below Hook When Opponent Turns On His Back", start: "1:55", second: 115},
      %{title: "Follow When Opponent Turns To Put On Half Guard", start: "8:15", second: 495},
      %{
        title: "2x1 Grip Isolating Elbow And Importance Of The Seat Belt Grip",
        start: "14:24",
        second: 864
      }
    ]

    t = 0

    socket =
      socket
      |> assign(:title, title)
      |> assign(:chapters, table)
      |> assign(:video_url, video_url(t))

    {:ok, socket}
  end

  defp video_url(t) do
    "//player.bilibili.com/player.html?aid=620007341&bvid=BV1U84y197Qd&cid=1310214612&p=1&t=#{t}"
  end

  def handle_event("jump", %{"value" => t} = params, socket) do
    IO.puts("hoooo #{inspect(params)}")

    {:noreply, assign(socket, :video_url, video_url(t))}
  end

  def handle_event("location_start", %{"value" => t} = params, socket) do
    IO.puts("hoooo #{inspect(params)}")

    {:noreply, assign(socket, :video_url, video_url(t))}
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end
end
