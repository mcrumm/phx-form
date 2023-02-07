defmodule PartyWeb.MoreComponents do
  @moduledoc """
  More UI components
  """
  use Phoenix.Component

  @doc """
  Dumps vars for debugging.

  Refer also to `PartyWeb.DBG.debug_html/4`.
  """
  attr :var, :any, required: true, doc: "The var to be dumped"

  def dump(assigns), do: ~H"<%= dbg(@var) %>"

  @doc """
  Renders content divided into steps.
  """
  attr :active, :integer, required: true

  slot :step, required: true do
    attr :navigate, :string, required: true
    attr :label, :string, required: true
    attr :description, :string
  end

  def stepper(assigns) do
    ~H"""
    <nav aria-label="Progress">
      <ol role="list" class="space-y-4 md:flex md:space-y-0 md:space-x-8">
        <li :for={{step, i} <- Enum.with_index(@step)} class="md:flex-1">
          <.link
            aria-current={i == @active && "step"}
            patch={step.navigate}
            class={
              cond do
                i < @active ->
                  # completed step
                  "group flex flex-col border-l-4 border-indigo-600 py-2 pl-4 hover:border-indigo-800 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"

                i == @active ->
                  # current step
                  "flex flex-col border-l-4 border-indigo-600 py-2 pl-4 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"

                true ->
                  # upcoming step
                  "group flex flex-col border-l-4 border-gray-200 py-2 pl-4 hover:border-gray-300 md:border-l-0 md:border-t-4 md:pl-0 md:pt-4 md:pb-0"
              end
            }
          >
            <span class={
              cond do
                i < @active ->
                  # completed step
                  "text-sm font-medium text-indigo-600 group-hover:text-indigo-800"

                i == @active ->
                  # current step
                  "text-sm font-medium text-indigo-600"

                true ->
                  # upcoming step
                  "text-sm font-medium text-gray-500 group-hover:text-gray-700"
              end
            }>
              <%= step.label %>
            </span>
            <span :if={Map.get(step, :description)} class="text-sm font-medium">
              <%= step.description %>
            </span>
          </.link>
        </li>
      </ol>
    </nav>
    """
  end

  @doc """
  Renders a form as a series of step-based fieldsets.
  """
  attr :for, :any, required: true, doc: "An existing form or the form source data."
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"
  attr :active, :integer, required: true, doc: "The active step index."

  attr :rest, :global,
    include: ~w(autocomplete name rel enctype novalidate target),
    doc: "Additional HTML attributes to add to the form tag."

  slot :fieldset, required: true do
    attr :name, :atom, required: true, doc: "The fieldset name."
    attr :for, :list, required: true, doc: "The list of fields owned by this fieldset."
    attr :class, :string
    attr :legend, :string
    attr :hidden, :boolean
  end

  def step_form(assigns) do
    assigns =
      assigns
      |> update(:for, fn data -> to_form(data, []) end)
      |> update(:fieldset, fn fieldsets, assigns ->
        for fieldset <- fieldsets do
          fieldset
          |> Map.put(:id, "#{assigns.for.id}-#{fieldset.name}")
          |> Map.update!(:name, &"#{assigns.for.id}[#{&1}]")
        end
      end)

    ~H"""
    <.form for={@for} as={@as} {@rest}>
      <%= for {fieldset, index} <- Enum.with_index(@fieldset) do %>
        <% # ---Inactive fieldset--- %>
        <fieldset :if={index !== @active} name={fieldset.name} id={fieldset.id}>
          <%= for field <- fieldset.for, field = @for[field] do %>
            <.dump :if={false} var={field} />
            <input type="hidden" name={field.name} value={field.value} />
          <% end %>
          <.dump :if={false} var={@for} />
        </fieldset>

        <% # ---Active fieldset--- %>
        <fieldset
          :if={index === @active}
          class={Map.get(fieldset, :class)}
          name={fieldset.name}
          id={fieldset.id}
        >
          <legend :if={Map.get(fieldset, :legend)}><%= fieldset.legend %></legend>
          <.dump :for={field <- fieldset.for} :if={false} var={@for[field]} />
          <%= render_slot(fieldset) %>
        </fieldset>
      <% end %>
    </.form>
    """
  end
end
