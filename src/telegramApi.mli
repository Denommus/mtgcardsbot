type user = <id : int; is_bot: Js.boolean; first_name : string; last_name : string; username : string; language_code : string> Js.t

type inlineQuery = <id : string; from : user; query : string; offset : string> Js.t

type options

val options : ?polling:bool -> options

type bot

val bot : string -> options -> bot

val onInlineQuery : bot -> (inlineQuery -> unit) -> unit
