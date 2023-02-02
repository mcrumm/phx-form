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
  Renders a conditional subform.
  """
  attr :for, Phoenix.HTML.FormField, required: true, doc: "The form field data."
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
end
