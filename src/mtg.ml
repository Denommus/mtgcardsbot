open Bs_node_fetch

type image_uris = {
  large: string;
  small: string;
  normal: string;
}

type card = {
  name : string;
  image_uris: image_uris;
  id : string
}

type cards = {
  cards : card array;
}

module Decode = struct
  let image_uris json =
    let open Json.Decode in {
      large = json |> optional (field "large" string) |> Js.Option.getWithDefault "";
      small = json |> optional (field "small" string) |> Js.Option.getWithDefault "";
      normal = json |> optional (field "normal" string) |> Js.Option.getWithDefault "";
    }

  let card json =
    let open Json.Decode in {
      name = json |> field "name" string;
      image_uris = json |> field "image_uris" image_uris;
      id = json |> field "id" string;
    }

  let cards json =
    let open Json.Decode in {
      cards = json |> field "data" (array card);
    }
end

let searchCard name =
  fetch ("https://api.scryfall.com/cards/search?q=" ^ name)
  |> Js.Promise.then_ Response.text
  |> Js.Promise.then_ (fun text -> let cards = Js.Json.parseExn text |> Decode.cards in
                        Js.Promise.resolve cards.cards)
  |> Js.Promise.catch (fun err -> Js.log err; Js.Promise.resolve [||])
