open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let port = try Sys.getenv "PORT" |> int_of_string with
  | Not_found -> 8080

let telegramBot = bot token @@ TelegramApi.options ~polling:true

let () =
  onInlineQuery telegramBot (fun query ->
      let open Js.Promise in
      Mtg.searchCard (query##query)
      |> then_ (fun cards ->
          answerInlineQuery telegramBot query
            (Array.to_list cards
             |> List.filter (fun (card : Mtg.card) -> card.imageUrl <> "")
             |> List.map (fun (card : Mtg.card) -> makeInlineQueryResultPhoto ~id:card.id ~photo_url:card.imageUrl ~thumb_url:card.imageUrl ())
             |> Array.of_list))
      |> ignore);
  let open Express in
  let app = express () in
  App.get app ~path:"/" @@ Middleware.from (fun _ res _ -> Response.sendString res "Hello, world!");
  App.listen app ~port:port ()
