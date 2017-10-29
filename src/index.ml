open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let telegramBot = bot token @@ TelegramApi.options ~polling:true

let () =
  onInlineQuery telegramBot (fun query ->
    Js.log query;
    answerInlineQuery telegramBot query [|
      makeInlineQueryResultArticle ~id:"foo" ~title:"bar" ~input_message_content:(makeInputTextMessageContent ~message_text:"baz" ())
    |]
    |> Js.Promise.then_ (fun x -> Js.log x; x)
    |> ignore)
