open Bs_node_fetch

type card = {
  name : string;
  imageUrl : string;
  id : string
}

type cards = {
  cards : card array;
}

module Decode = struct
  let card json =
    let open Json.Decode in {
      name = json |> field "name" string;
      imageUrl = json |> optional (field "imageUrl" string) |> Js.Option.getWithDefault "";
      id = json |> field "id" string;
    }

  let cards json =
    let open Json.Decode in {
      cards = json |> field "cards" (array card);
    }
end

let searchCard name =
  fetch ("https://api.magicthegathering.io/v1/cards?pageSize=50&name=" ^ name)
  |> Js.Promise.then_ Response.text
  |> Js.Promise.then_ (fun text -> let cards = Js.Json.parseExn text |> Decode.cards in
                        Js.Promise.resolve cards.cards)
  |> Js.Promise.catch (fun err -> Js.log err; Js.Promise.resolve [||])
