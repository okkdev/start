module Config exposing (..)


type alias Bookmarks =
    List Bookmark


type alias Bookmark =
    { label : String
    , url : String
    }


bookmarks : Bookmarks
bookmarks =
    [ { label = "Test"
      , url = "https://test.com"
      }
    , { label = "Test2"
      , url = "https://test2.com"
      }
    ]
