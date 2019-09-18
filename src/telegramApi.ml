type inputMessageContent

external makeInputTextMessageContent : message_text:string -> ?parse_mode:string -> ?disable_web_page_preview:bool -> unit -> inputMessageContent = "" [@@bs.obj]

type inlineQueryResult

external extInlineQueryResultArticle : _type:string -> id:string -> title:string -> input_message_content:inputMessageContent -> inlineQueryResult = "" [@@bs.obj]

let makeInlineQueryResultArticle = extInlineQueryResultArticle ~_type:"article"

external extInlineQueryResultPhoto : _type:string -> id:string -> photo_url:string -> thumb_url:string -> ?title:string -> unit -> inlineQueryResult = "" [@@bs.obj]

let makeInlineQueryResultPhoto = extInlineQueryResultPhoto ~_type:"photo"

type user = <id : int; is_bot: bool; first_name : string; last_name : string; username : string; language_code : string> Js.t

type inlineQuery = <id : string; from : user; query : string; offset : string> Js.t

type options

external externalOptions : polling:bool -> ?webHook:(<port : string> Js.t) -> unit -> options = "" [@@bs.obj]

let options ?polling:(p=false) = externalOptions ~polling:p

class type _bot =
  object
    method setWebHook : string -> unit
    method processUpdate : Js.Json.t Js.Dict.t -> unit
    method on : string -> ('a Js.t -> unit [@bs]) -> unit
    method answerInlineQuery : string -> inlineQueryResult array -> 'a Js.Promise.t
  end [@bs]

type bot = _bot Js.t

external bot : string -> options -> bot = "node-telegram-bot-api" [@@bs.new] [@@bs.module]

let setWebHook (bot : bot) str = bot##setWebHook str

let processUpdate (bot : bot) obj = bot##processUpdate obj

let onInlineQuery (bot : bot) f = bot##on "inline_query" (fun [@bs] msg -> f msg)

let onMessage (bot : bot) f = bot##on "message" (fun [@bs] msg -> f msg)

let onPollingError (bot : bot) f = bot##on "polling_error" (fun [@bs] msg -> f msg)

let answerInlineQuery (bot : bot) query results = bot##answerInlineQuery query##id results
