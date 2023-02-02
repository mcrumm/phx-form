defmodule PartyWeb.DBG do
  @moduledoc """
  Debug helpers for the web.
  """

  def debug_html(code, options, env, :dev) do
    component? = Macro.Env.required?(env, Phoenix.Component)
    assigns? = env |> Macro.Env.vars() |> Keyword.has_key?(:assigns)
    {_, arity} = env.function

    if component? and assigns? and arity === 1 and options[:to] !== :stdio do
      quote do
        unquote(__MODULE__).__html__(unquote(code), unquote(options))
      end
    else
      result = Macro.dbg(code, options, env)

      quote do
        # avoids warnings about unused variables
        if false, do: unquote(code)
        unquote(result)
      end
    end
  end

  def debug_html(code, _options, _caller, _config_env) do
    quote do
      # avoids warnings about unused variables
      if false, do: unquote(code)
      nil
    end
  end

  # pre border: class='outline-1 outline-pink-500 outline-dashed outline-offset-4 my-2'
  def __html__(result, options) do
    {:safe,
     "<code><pre>" <>
       Kernel.inspect(result,
         pretty: true,
         limit: options[:limit] || :infinity,
         printable_limit: options[:printable_limit] || :infinity,
         width: options[:width] || 34
       ) <> "</pre></code>"}
  end
end
