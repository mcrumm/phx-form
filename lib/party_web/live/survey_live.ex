defmodule PartyWeb.SurveyLive do
  use PartyWeb, :live_view

  def render(assigns) do
    ~H"""
    <nav class="flex py-6" aria-label="Breadcrumb">
      <ol role="list" class="flex items-center space-x-4">
        <li>
          <div>
            <.link href={~p"/"} class="text-gray-400 hover:text-gray-500">
              <Heroicons.home mini class="h-5 w-5 flex-shrink-0" />
              <span class="sr-only">Home</span>
            </.link>
          </div>
        </li>

        <li>
          <div class="flex items-center">
            <Heroicons.chevron_right mini class="h-5 w-5 flex-shrink-0 text-gray-400" />
            <.link
              href={~p"/survey"}
              class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700"
            >
              Survey
            </.link>
          </div>
        </li>

        <%!-- todo: current step breadcrumb --%>
      </ol>
    </nav>

    <nav aria-label="Progress">
      <ol role="list" class="space-y-4 md:flex md:space-y-0 md:space-x-8">
        <li class="md:flex-1">
          <!-- Current Step -->
          <.link
            navigate={~p"/survey/steps/1"}
            class="flex flex-col border-l-4 border-indigo-600 py-2 pl-4 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"
            aria-current="step"
          >
            <span class="text-sm font-medium text-indigo-600">Step 1</span>
          </.link>
        </li>

        <li class="md:flex-1">
          <!-- Upcoming Step -->
          <.link
            navigate={~p"/survey/steps/2"}
            class="group flex flex-col border-l-4 border-gray-200 py-2 pl-4 hover:border-gray-300 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"
          >
            <span class="text-sm font-medium text-gray-500 group-hover:text-gray-700">Step 2</span>
          </.link>
        </li>

        <li class="md:flex-1">
          <!-- Upcoming Step -->
          <.link
            navigate={~p"/survey/steps/3"}
            class="group flex flex-col border-l-4 border-gray-200 py-2 pl-4 hover:border-gray-300 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"
          >
            <span class="text-sm font-medium text-gray-500 group-hover:text-gray-700">Step 3</span>
          </.link>
        </li>
      </ol>
    </nav>

    <.header class="py-4"><%= @page_title %></.header>

    <div class="grid gap-4 grid-cols-3 grid-rows-1">
      <div>
        <form>
          <.reform :let={f} for={to_fieldset(@form[:step_1])} active={@live_action == :step_1}>
            <.input type="text" field={f[:name]} label="What is your name?" />
          </.reform>

          <.reform :let={f} for={to_fieldset(@form[:step_2])} active={@live_action == :step_2}>
            <.input type="text" field={f[:quest]} label="What is your quest?" />
          </.reform>

          <.reform :let={f} for={to_fieldset(@form[:step_3])} active={@live_action == :step_3}>
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

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, :page_title, page_title(socket.assigns.live_action))}
  end

  def mount(_params, _session, socket) do
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

    {:ok, assign(socket, last_event: nil, response: nil, form: new_survey_form(initial_values))}
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

  attr :for, PartyWeb.Fieldset, required: true, doc: "The form field data."
  attr :active, :boolean, required: true, doc: "Whether or not this fieldset is currently active"
  slot :inner_block, required: true

  def reform(%{active: true} = assigns) do
    ~H"""
    <p>reform for <.dump var={@for} /></p>
    """
  end

  def reform(%{active: false} = assigns) do
    ~H"""
    <p>todo: render hidden fields</p>
    """
  end

  def to_fieldset(%Phoenix.HTML.FormField{} = field) do
    %PartyWeb.Fieldset{}
  end
end
