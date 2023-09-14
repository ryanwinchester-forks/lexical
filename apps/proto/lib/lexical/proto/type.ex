defmodule Lexical.Proto.Type do
  alias Lexical.Proto.CompileMetadata

  alias Lexical.Proto.Macros.{
    Access,
    Inspect,
    Json,
    Match,
    Meta,
    Parse,
    Struct,
    Typespec
  }

  defmacro deftype(types) do
    caller_module = __CALLER__.module
    CompileMetadata.add_type_module(caller_module)

    quote location: :keep do
      unquote(Json.build(caller_module))
      unquote(Inspect.build(caller_module))
      unquote(Access.build())
      unquote(Struct.build(types, __CALLER__))

      @type t :: unquote(Typespec.typespec(types, __CALLER__))

      unquote(Parse.build(types))
      unquote(Match.build(types, caller_module))
      unquote(Meta.build(types))

      def __meta__(:type) do
        :type
      end

      def __meta__(:param_names) do
        unquote(Keyword.keys(types))
      end
    end
  end
end
