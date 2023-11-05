defmodule BjjcourseWeb.BilibiliLive do
  use Phoenix.Component
  use Phoenix.LiveView
  import BjjcourseWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="container mx-auto">
      <div class="flex flex-row">
        <div class="flex-none w-1/3">
          <aside class="w-full pt-1 pr-1 dark:bg-gray-900 dark:text-gray-100">
            <nav class="space-y-8 text-sm">
              <%= for {chapter, index} <- Enum.with_index(@chapters, 1) do %>
                <div class="space-y-2 w-full">
                  <h2 class="text-sm font-semibold tracki uppercase dark:text-gray-400">
                    <%= chapter %>
                  </h2>
                  <div class="flex flex-col space-y-1">
                    <%= for [title, start] <- @table[chapter]["chapter"] do %>
                      <div
                        class="flex flex-row"
                        phx-click={
                          JS.push("location_start",
                            value: %{
                              aid: @table[chapter]["aid"],
                              vid: @table[chapter]["vid"],
                              cid: @table[chapter]["cid"],
                              start: start
                            }
                          )
                        }
                      >
                        <div class="basis-5/6 text-left"><%= title %></div>
                        <div class="basis-1/6 text-right"><%= start %></div>
                      </div>
                    <% end %>
                  </div>
                </div>
              <% end %>
            </nav>
          </aside>
        </div>
        <div class="grow pt-2">
          <iframe
            id="course"
            height="100%"
            width="100%"
            position="absolute"
            src={@video_url}
            scrolling="yes"
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

    table = %{
      "Volume 1" => %{
        "vid" => "BV1U84y197Qd",
        "aid" => "620007341",
        "cid" => "1310214612",
        "chapter" => [
          ["Intro", "0"],
          ["Primordial Details And Concepts - Intro", "1:08"],
          ["Slide Below Hook When Opponent Turns On His Back", "1:55"],
          ["Follow When Opponent Turns To Put On Half Guard", "8:15"],
          ["2x1 Grip Isolating Elbow And Importance Of The Seat Belt Grip", "14:24"],
          ["Concept Of Putting Shin On The Calf", "22:11"],
          [
            "Grampo System When The Opponent Has 4 Supports And Closes The Space To Place The Hook",
            "27:55"
          ],
          ["Understand What Support Hand And Attack Hand Are", "37:04"],
          ["Concept Attack The Neck To Put The Hook", "41:28"],
          ["Always Place The Hook Close To The Waist", "44:05"],
          [
            "Place The Shoulder Behind The Neck For More Control Of The Bow And Arrow Choke",
            "45:48"
          ],
          [
            "In The Case Of 1 Hook Only Always Attack The Bow And Arrow Choke With The Opposite Arm",
            "50:08"
          ],
          ["Importance Of The Belt Grip To Control The Opponent's Height", "55:22"]
        ]
      },
      "Volume 2" => %{
        # <iframe src="//player.bilibili.com/player.html?aid=620007341&bvid=BV1U84y197Qd&cid=1310214697&p=3" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
        "vid" => "BV1U84y197Qd",
        "aid" => "620007341",
        "cid" => "1310214697",
        "chapter" => [
          ["Back Takes From The Guard - Intro", "0"],
          ["Back Take Of The Back Crossing My Opponent's Arm", "0:58"],
          ["Back Take From Close Guard Shrinking The Knee", "7:18"],
          [
            "Variation Of The Previous Technique When The Opponent Throws The Weight Forward",
            "17:47"
          ],
          [
            "Variation Of The Prior Technique When The Opponent Puts The Knee On The Floor",
            "29:16"
          ],
          [
            "Back Take Of The Closed Guard Rotating Inside The Legs When My Opponent Stands",
            "36:02"
          ],
          ["Contra Attack From Double Under Passing Taking The Back", "40:36"],
          ["Basic Back Take From Half-guard", "46:51"],
          ["Back Take From Electric Chair", "55:43"]
        ]
      }
    }

    chapters = ["Volume 1", "Volume 2"]

    %{"vid" => vid, "aid" => aid, "cid" => cid} = Map.get(table, "Volume 1")

    socket =
      socket
      |> assign(:title, title)
      |> assign(:table, table)
      |> assign(:chapters, chapters)
      |> assign(:video_url, video_url(vid, aid, cid, 0))

    {:ok, socket}
  end

  defp video_url(vid, aid, cid, t) do
    "//player.bilibili.com/player.html?aid=#{aid}&bvid=#{vid}&cid=#{cid}&page=2&t=#{t}&autoplay=0"
  end

  def seek_timestamp(start) do
    case String.split(start, ":") do
      [t] ->
        String.to_integer(t)

      [m, t] ->
        String.to_integer(m) * 60 + String.to_integer(t)

      [h, m, t] ->
        String.to_integer(h) * 3600 + String.to_integer(m) * 60 + String.to_integer(t)

      [] ->
        0
    end
  end

  def handle_event(
        "location_start",
        %{"aid" => aid, "vid" => vid, "cid" => cid, "start" => start} = params,
        socket
      ) do
    t = seek_timestamp(start)

    {:noreply, assign(socket, :video_url, video_url(vid, aid, cid, t))}
  end

  def handle_event(_, _, socket) do
    {:noreply, socket}
  end
end
