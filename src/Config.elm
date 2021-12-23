module Config exposing (..)


type alias Shortcuts =
    List Shortcut


type alias Shortcut =
    { label : String
    , url : String
    }


type Theme
    = Dark
    | Light


defaultTheme : Theme
defaultTheme =
    Dark


shortcuts : Shortcuts
shortcuts =
    [ { label = "Test"
      , url = "https://test.com"
      }
    , { label = "Test2"
      , url = "https://test2.com"
      }
    ]
