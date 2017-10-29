type user = <id : int; is_bot: Js.boolean; first_name : string; last_name : string; username : string; language_code : string> Js.t

type inlineQuery = <id : string; from : user; query : string; offset : string> Js.t

type options

external externalOptions : polling:Js.boolean -> options = "" [@@bs.obj]

let options ?polling:(p=false) = externalOptions ~polling:(Js.Boolean.to_js_boolean p)

class type _bot =
  object
    method on : string -> ('a Js.t -> unit [@bs]) -> unit
  end [@bs]

type bot = _bot Js.t

external bot : string -> options -> bot = "node-telegram-bot-api" [@@bs.new] [@@bs.module]

let onInlineQuery (bot : bot) f = bot##on "inline_query" (fun [@bs] msg -> f msg)
