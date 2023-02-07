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
      <:step label="Step 3" description="Evaluation" navigate={~p"/survey/steps/3"} />
    </.stepper>

    <.header class="py-4"><%= @page_title %></.header>

    <div class="grid gap-4 grid-cols-3 grid-rows-1">
      <div>
        <p class="block text-sm font-semibold leading-6 text-zinc-900">Form</p>
        <.step_form for={@form} active={@active_step_index} phx-change="change" phx-submit="submit">
          <:fieldset :let={f} for={@form[:step_1]}>
            <.input type="text" field={f[:name]} label="What is your name?" />
          </:fieldset>

          <:fieldset :let={f} for={@form[:step_2]}>
            <.input type="text" field={f[:quest]} label="What is your quest?" />
          </:fieldset>

          <:fieldset :let={f} for={@form[:step_3]}>
            <.input
              type="select"
              field={f[:favorite_color]}
              label="What...is your favorite color?"
              prompt="Choose a color"
              options={[{"Red", "red"}, {"Green", "green"}, {"Blue", "blue"}]}
            />
            <div class="py-4">
              <.button type="submit">Submit</.button>
            </div>
          </:fieldset>
        </.step_form>
      </div>

      <div>
        <p class="block text-sm font-semibold leading-6 text-zinc-900">FormData</p>
        <.dump :if={@live_action != :index} var={@form[@live_action].value} />
      </div>

      <div>
        <p class="block text-sm font-semibold leading-6 text-zinc-900">Last Form Submit</p>
        <.dump :if={@response} var={@response} />
        <p :if={@response}>at <%= @last_event %></p>
      </div>
    </div>
    """
  end

  def handle_event(event, %{"survey" => survey_params}, socket)
      when event in ["change", "submit"] do
    {:noreply,
     socket
     |> update(:response, fn old -> if event == "submit", do: survey_params, else: old end)
     |> update(:form, fn form -> dbg(%{form | params: survey_params}) end)
     |> update(:last_event, fn old ->
       if event == "submit", do: DateTime.utc_now(), else: old
     end)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: new_survey_form())
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

  defp new_survey_form(params \\ %{}) do
    form = to_form(params, as: :survey, id: "survey-form")

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

    # puts the initial values to `form.data` so they will be returned
    # by `Phoenix.HTML.Form.input_value/2`.
    dbg(%Phoenix.HTML.Form{form | data: initial_values})
  end

  defp page_title(:index), do: "Survey"
  defp page_title(:step_1), do: "Step 1"
  defp page_title(:step_2), do: "Step 2"
  defp page_title(:step_3), do: "Step 3"
end
