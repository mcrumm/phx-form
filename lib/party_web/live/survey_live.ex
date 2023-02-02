defmodule PartyWeb.SurveyLive do
  use PartyWeb, :live_view

  def render(assigns) do
    ~H"""
    <nav class="flex py-6" aria-label="Breadcrumb">
      <ol role="list" class="flex items-center space-x-4">
        <li>
          <div>
            <.link navigate={~p"/"} class="text-gray-400 hover:text-gray-500">
              <Heroicons.home mini class="h-5 w-5 flex-shrink-0" />
              <span class="sr-only">Home</span>
            </.link>
          </div>
        </li>

        <li>
          <div class="flex items-center">
            <Heroicons.chevron_right mini class="h-5 w-5 flex-shrink-0 text-gray-400" />
            <.link
              navigate={~p"/survey"}
              class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700"
            >
              Survey
            </.link>
          </div>
        </li>

        <%!-- todo: current step breadcrumb --%>
      </ol>
    </nav>

    <.stepper active={@active_step_index}>
      <:step label="Step 1" description="Employee Information" navigate={~p"/survey/steps/1"} />
      <:step label="Step 2" description="Career Goals" navigate={~p"/survey/steps/2"} />
      <:step label="Step 3" navigate={~p"/survey/steps/3"} />
    </.stepper>

    <.header class="py-4"><%= @page_title %></.header>

    <div class="grid gap-4 grid-cols-3 grid-rows-1">
      <div>
        <form>
          <.reform :let={f} for={@form[:step_1]} active={@live_action == :step_1}>
            <.input type="text" field={f[:name]} label="What is your name?" />
          </.reform>

          <.reform :let={f} for={@form[:step_2]} active={@live_action == :step_2}>
            <.input type="text" field={f[:quest]} label="What is your quest?" />
          </.reform>

          <.reform :let={f} for={@form[:step_3]} active={@live_action == :step_3}>
            <.input
              type="text"
              field={f[:color]}
              label="What...is your favorite color?"
              prompt="Choose a color"
              options={[{"Red", "red"}, {"green", "Green"}, {"Blue", "blue"}]}
            />
          </.reform>
        </form>
      </div>

      <div>
        <p class="block text-sm font-semibold leading-6 text-zinc-800">FormData</p>
        <.dump :if={@live_action != :index} var={@form[@live_action].value} />
      </div>

      <div>
        <p class="block text-sm font-semibold leading-6 text-zinc-800">Response</p>
        <.dump :if={@response} var={@response} />
        <p>Last form event: <%= @last_event %></p>
      </div>
    </div>
    """
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_new_form()
      |> assign(last_event: nil, response: nil)

    {:ok, socket}
  end

  defp apply_action(socket, live_action, _params) do
    socket
    |> assign(:page_title, page_title(live_action))
    |> set_active_step(live_action)
  end

  defp set_active_step(socket, live_action) do
    index =
      Enum.find_index([:step_1, :step_2, :step_3], fn
        ^live_action -> true
        _ -> false
      end)

    assign(socket, active_step_index: index || -1, active_step: live_action)
  end

  defp assign_new_form(socket) do
    initial_values = %{
      :step_1 => %{
        :name => ""
      },
      :step_2 => %{
        :quest => ""
      },
      :step_3 => %{
        :favorite_color => ""
      }
    }

    assign(socket, form: new_survey_form(initial_values))
  end

  defp new_survey_form(initial_values \\ %{}) do
    form = to_form(initial_values, as: :survey)

    # puts the initial values to `form.data` so they will be returned
    # by `Phoenix.HTML.Form.input_value/2`.
    %Phoenix.HTML.Form{form | data: initial_values}
  end

  defp page_title(:index), do: "Survey"
  defp page_title(:step_1), do: "Step 1"
  defp page_title(:step_2), do: "Step 2"
  defp page_title(:step_3), do: "Step 3"
end
