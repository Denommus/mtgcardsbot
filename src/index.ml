let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let telegramBot = TelegramApi.bot token @@ TelegramApi.options ~polling:true

let () =
  TelegramApi.onInlineQuery telegramBot (fun query ->
    Js.log query)
