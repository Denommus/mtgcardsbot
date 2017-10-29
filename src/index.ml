open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let port = try Sys.getenv "PORT" with
  | Not_found -> "8080"

let url = try Sys.getenv "APP_URL" with
  | Not_found -> "https://mtgcardsbot.herokuapp.com"

let telegramBot = bot token @@ TelegramApi.options ~webhook:([%bs.obj { port = port }]) ()


let () =
  setWebHook telegramBot (url ^ "/bot" ^ token);
  onInlineQuery telegramBot (fun query ->
      let open Js.Promise in
      Mtg.searchCard (query##query)
      |> then_ (fun cards ->
          answerInlineQuery telegramBot query
            (Array.to_list cards
             |> List.filter (fun (card : Mtg.card) -> card.imageUrl <> "")
             |> List.map (fun (card : Mtg.card) -> makeInlineQueryResultPhoto ~id:card.id ~photo_url:card.imageUrl ~thumb_url:card.imageUrl ())
             |> Array.of_list))
      |> then_ (fun _ -> resolve ())
      |> catch (fun err -> Js.log err; resolve ())
      |> ignore)
