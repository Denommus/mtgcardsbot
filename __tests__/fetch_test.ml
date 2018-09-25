open Jest


let () =
  describe "Resolute Archangel" (fun () ->
      testPromise "Resolute Archangel" (fun () ->
          Mtg.searchCard "Resolute Archangel"
          |> Js.Promise.then_ (fun cards ->
              let open Expect in
              Js.Promise.resolve
                (expect (Array.length cards) |> toBeGreaterThan 0))));
  describe "Resolute Archangel image" (fun () ->
      testPromise "Resolute Archangel" (fun () ->
          let open Mtg in
          searchCard "Resolute Archangel"
          |> Js.Promise.then_ (fun cards ->
              let open Expect in
              let card = Array.get cards 0 in
              Js.Promise.resolve
                (expect card.image_uris.large |> toBe "https://img.scryfall.com/cards/large/en/m15/28.jpg?1517813031"))));
  describe "Tibalt image" (fun () ->
      testPromise "Tibalt" (fun () ->
          let open Mtg in
          searchCard "Tibalt"
          |> Js.Promise.then_ (fun cards ->
              let open Expect in
              let card = Array.get cards 0 in
              Js.Promise.resolve
                (expect (card.image_uris.large, card.image_uris.small) |> toEqual ("https://img.scryfall.com/cards/large/front/f/a/fa56d53c-836c-483d-988d-a288d0ad91bb.jpg?1537149837", "https://img.scryfall.com/cards/small/front/f/a/fa56d53c-836c-483d-988d-a288d0ad91bb.jpg?1537149837")))))
