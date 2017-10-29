type inputMessageContent

val makeInputTextMessageContent : message_text:string -> ?parse_mode:string -> ?disable_web_page_preview:Js.boolean -> unit -> inputMessageContent

type inlineQueryResult

val makeInlineQueryResultArticle : id:string -> title:string -> input_message_content:inputMessageContent -> inlineQueryResult

val makeInlineQueryResultPhoto : id:string -> photo_url:string -> thumb_url:string -> ?title:string -> unit -> inlineQueryResult

type user = <id : int; is_bot: Js.boolean; first_name : string; last_name : string; username : string; language_code : string> Js.t

type inlineQuery = <id : string; from : user; query : string; offset : string> Js.t

type options

val options : ?polling:bool -> ?webHook:< port : string > Js.t -> unit -> options

type bot

val bot : string -> options -> bot

val setWebHook : bot -> string -> unit

val processUpdate : bot -> Js.Json.t Js.Dict.t -> unit

val onInlineQuery : bot -> (inlineQuery -> unit) -> unit

val onMessage : bot -> (inlineQuery -> unit) -> unit

val answerInlineQuery : bot -> inlineQuery -> inlineQueryResult array -> 'a Js.Promise.t
