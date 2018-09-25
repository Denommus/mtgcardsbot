open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let port = try Sys.getenv "PORT" |> int_of_string with
  | Not_found -> 8080

let url = try Sys.getenv "APP_URL" with
  | Not_found -> "https://bot-mtgcardsbot.getup.io"

let fullUrl = url ^ "/bot" ^ token

let rec take len list = match (len, list) with
  | (0, _) -> []
  | (_, []) -> []
  | (k, x::xs) -> x :: (take (k-1) xs)

let telegramBot = bot token @@ TelegramApi.options ~webHook:([%bs.obj { port = string_of_int port }]) ()

let () =
  setWebHook telegramBot fullUrl;
  onInlineQuery telegramBot (fun query ->
      let open Js.Promise in
      Mtg.searchCard (query##query)
      |> then_ (fun cards ->
          let response = Array.to_list cards
                         |> List.map (fun (card : Mtg.card) -> makeInlineQueryResultPhoto ~id:card.id ~photo_url:card.image_uris.large ~thumb_url:card.image_uris.small ())
                         |> take 20
                         |> Array.of_list in
          Js.log response;
          Js.log query##id;
          answerInlineQuery telegramBot query response)
      |> catch (fun err ->
          Js.log err;
          let messageContent = makeInputTextMessageContent ~message_text:"Error" () in
          let response = [| makeInlineQueryResultArticle ~id:query##id ~title:"error" ~input_message_content:messageContent |] in
          answerInlineQuery telegramBot query response)
      |> ignore);
  onMessage telegramBot (fun _ -> Js.log "I'm alive!")
