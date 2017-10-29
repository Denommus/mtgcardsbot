open TelegramApi

let token = Sys.getenv "TOKEN" (* This value is required, it's best if the system throws when it's not found *)

let port = try Sys.getenv "PORT" |> int_of_string with
  | Not_found -> 8080

let url = try Sys.getenv "APP_URL" with
  | Not_found -> "https://mtgcardsbot.herokuapp.com"

let fullUrl = url ^ "/bot" ^ token

let telegramBot = bot token @@ TelegramApi.options ()

let () =
  setWebHook telegramBot fullUrl;
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
  App.get app ~path:"/" @@ Middleware.from (fun _ res _ ->
      Response.sendString res "Hello, world!");
  App.post app ~path:("/bot" ^ token) @@ Middleware.from (fun req res _ ->
      Js.log @@ Request.bodyJSON req;
      Request.bodyJSON req
      |> Js.Option.getExn
      |> Js.Json.decodeObject
      |> Js.Option.getExn
      |> processUpdate telegramBot;
      Response.sendString res "Ok");
  App.listen app ~port:port ()
