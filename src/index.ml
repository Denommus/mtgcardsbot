open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let port = try Sys.getenv "PORT" |> int_of_string with
  | Not_found -> 8080

let url = try Sys.getenv "APP_URL" with
  | Not_found -> "https://bot-mtgcardsbot.getup.io"

let fullUrl = url ^ "/bot" ^ token

let telegramBot = bot token @@ TelegramApi.options ~webHook:([%bs.obj { port = string_of_int port }]) ()

let () =
  setWebHook telegramBot fullUrl;
  onInlineQuery telegramBot (fun query ->
      let open Js.Promise in
      Mtg.searchCard (query##query)
      |> then_ (fun cards ->
          answerInlineQuery telegramBot query
            (Array.to_list cards
             |> List.filter (fun (card : Mtg.card) -> card.imageUrl <> "")
             |> List.map (fun (card : Mtg.card) -> makeInlineQueryResultPhoto ~id:card.id ~photo_url:card.imageUrl ~thumb_url:card.thumbUrl ())
             |> Array.of_list))
      |> ignore);
  onMessage telegramBot (fun _ -> Js.log "I'm alive!")
